import 'package:flutter/material.dart';
import 'package:news_c10_str/models/source_reposne.dart';
import 'package:news_c10_str/screens/news_item.dart';
import 'package:news_c10_str/screens/source_item.dart';
import 'package:news_c10_str/shared/network/remote/api_manager.dart';

import '../models/NewsResponse.dart';

class NewsTab extends StatefulWidget {
  List<Sources> sources;

  NewsTab({super.key, required this.sources});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  int selectedIndex = 0;
  int page = 1;
  int pageSize = 20;
  late ScrollController scrollController;
  List<Articles> articlesList = [];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge) {
          print("--------------------------AtEdge");
          if (scrollController.offset != 0 &&
              scrollController.position.pixels != 0) {
            setState(() {
              page++;
            });
            loadNews();
          }
        }
      },
    );
  }

  Future<void> loadNews() async {
    var newarticleList = await ApiManager.getNewsData(
      sourceId: widget.sources[selectedIndex].id ?? "",
      page: page,
      pageSize: pageSize,
    );
    setState(() {});
    articlesList.addAll(newarticleList?.articles ?? []);
    print(newarticleList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTabController(
            length: widget.sources.length,
            child: TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              onTap: (value) {
                setState(() {});
                selectedIndex = value;
                page = 1;
                articlesList.clear();
                loadNews();
              },
              indicatorColor: Colors.transparent,
              tabs: widget.sources
                  .map((e) => Tab(
                        child: SourceItem(
                          source: e,
                          isSelected:
                              widget.sources.elementAt(selectedIndex) == e,
                        ),
                      ))
                  .toList(),
            )),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                page = 1;
                pageSize = 20;
              });
              await loadNews();
            },
            child: ListView.separated(
              controller: scrollController,
              separatorBuilder: (context, index) => SizedBox(
                height: 12,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NewsItem(article: articlesList[index]),
                );
              },
              itemCount: articlesList.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
