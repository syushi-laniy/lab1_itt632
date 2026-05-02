import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'article.dart';

class CacheService {
  static const String key = "cached_articles";


  Future<void> saveArticles(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonList =
    articles.map((a) => jsonEncode(a.toJson())).toList();

    await prefs.setStringList(key, jsonList);
  }


  Future<List<Article>> getCachedArticles() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? jsonList = prefs.getStringList(key);

    if (jsonList == null) return [];

    return jsonList
        .map((item) => Article.fromJson(jsonDecode(item)))
        .toList();
  }
}