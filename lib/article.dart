// lib/article.dart
class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final String source; // Added source field for better UI

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    this.source = "News",
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      urlToImage: json['urlToImage'] != null &&
          json['urlToImage'].toString().isNotEmpty
          ? json['urlToImage']
          : 'https://via.placeholder.com/150',
      url: json['url'] ?? '',
      source: json['source'] != null ? json['source']['name'] ?? 'News' : 'News',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
    };
  }
}