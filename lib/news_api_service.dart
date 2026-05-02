import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';

class NewsApiService {
  final String apiKey = 'e6095e9a99e44c129d73a31d62dc12d1';
  final String baseUrl = 'https://newsapi.org/v2/';


  Future<List<Article>> fetchTeslaMalaysiaNews({
    required int page,
    int pageSize = 10,
  }) async {
    String lastMonth = DateTime.now()
        .subtract(Duration(days: 30))
        .toIso8601String()
        .split('T')[0];

    final String url = '${baseUrl}everything?'
        'q=tesla AND malaysia'
        '&from=$lastMonth'
        '&sortBy=publishedAt'
        '&page=$page'
        '&pageSize=$pageSize'
        '&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      return articlesJson
          .map((json) => Article.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }


  Future<List<Article>> searchNews(String query) async {
    final String url =
        '${baseUrl}everything?q=$query&sortBy=publishedAt&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'];

      return articlesJson
          .map((json) => Article.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}