import 'package:flutter/material.dart';

import '../shared/network/remote/api_manager.dart';
import 'news_item.dart';

class SearchTab extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: Icon(Icons.clear)),
      IconButton(
          onPressed: () {
            showResults(context);
          },
          icon: Icon(Icons.search)),

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchData();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text("please enter text to search"),
      );
    }
    return buildSearchData();
  }

  Widget buildSearchData() {
    return FutureBuilder(
      future: ApiManager.getNewsData(quary: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ));
        }
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        var articlesList = snapshot.data?.articles ?? [];
        if (articlesList.isEmpty) {
          return Center(child: Text("No Sources"));
        }
        return ListView.separated(
          separatorBuilder: (context, index) =>
              SizedBox(
                height: 12,
              ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: NewsItem(article: articlesList[index]),
            );
          },
          itemCount: articlesList.length,
        );
      },
    );
  }
}
