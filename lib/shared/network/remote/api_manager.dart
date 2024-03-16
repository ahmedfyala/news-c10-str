import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_c10_str/shared/components/constants.dart';

import '../../../models/NewsResponse.dart';
import '../../../models/source_reposne.dart';

class ApiManager {
// https://newsapi.org/v2/top-headlines/sources?apiKey=
  static Future<SourceResponse> getSources(String category) async {
    Uri url = Uri.https(Constants.BASE_URL, "/v2/top-headlines/sources",
        {"apiKey": "c6f6fed5d4e34dcabfd0ee601768981d", "category": category});
    http.Response resposne = await http.get(url);
    Map<String, dynamic> json = jsonDecode(resposne.body);

    return SourceResponse.fromJson(json);
  }

  static Future<NewsResponse> getNewsData(
      {String? sourceId, String? quary, int? pageSize, int? page}) async {
    Uri url = Uri.https(Constants.BASE_URL, "/v2/everything", {
      "sources": sourceId,
      "q": quary,
      "pageSize": pageSize.toString(),
      "page": page.toString()
    });
    var resposne = await http
        .get(url, headers: {"x-api-key": "c6f6fed5d4e34dcabfd0ee601768981d"});

    var json = jsonDecode(resposne.body);
    return NewsResponse.fromJson(json);
  }
}
