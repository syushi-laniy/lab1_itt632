// lib/article_detail_screen.dart

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'article.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      appBar: AppBar(
        title: Text(
          article.title.length > 40
              ? '${article.title.substring(0, 40)}...'
              : article.title,
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              Image.network(article.urlToImage),

            SizedBox(height: 20),

            Text(
              article.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            SizedBox(height: 16),

            Text(
              article.description,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.black87,
              ),
            ),

            SizedBox(height: 24),

            // Open article (WEB SAFE)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  html.window.open(article.url, "_blank");
                },
                child: Text("Read Full Article"),
              ),
            ),

            SizedBox(height: 30),

            // Dark mode toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}