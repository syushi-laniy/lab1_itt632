import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';
import 'config.dart';

class NewsApiService {
  final String baseUrl = Config.baseUrl;

  Future<List<Article>> fetchTopHeadlines() async {
    final response =
    await http.get(Uri.parse('${baseUrl}news'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
      json.decode(response.body);

      return jsonData
          .map((json) => Article.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}