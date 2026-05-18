import 'package:flutter/material.dart';
import 'article.dart';
import 'news_api_service.dart';
import 'article_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cache_service.dart';


void main() {
  runApp(NewsApp());
}

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: NewsHomePage(onToggleTheme: toggleTheme),
    );
  }
}

class NewsHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const NewsHomePage({Key? key, required this.onToggleTheme})
      : super(key: key);

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final NewsApiService api = NewsApiService();
  final CacheService cacheService = CacheService();

  List<Article> articles = [];
  bool isLoading = false;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  // ✅ FIXED LOAD (NO pagination, simple backend call)
  Future<void> loadNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newArticles = await api.fetchTopHeadlines();

      await cacheService.saveArticles(newArticles);

      setState(() {
        articles = newArticles;
        isLoading = false;
        isOffline = false;
      });
    } catch (e) {
      final cached = await cacheService.getCachedArticles();

      setState(() {
        articles = cached;
        isLoading = false;
        isOffline = true;
      });
    }
  }

  // ✅ SIMPLE SEARCH (FILTER LOCALLY)
  void search(String query) {
    setState(() {
      articles = articles
          .where((a) =>
          a.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void resetNews() {
    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetNews,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: widget.onToggleTheme,
        child: Icon(Icons.brightness_6),
      ),

      body: Column(
        children: [

          // 🔴 OFFLINE BANNER
          if (isOffline)
            Container(
              width: double.infinity,
              color: Colors.red,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Offline Mode - Cached Data",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

          // 🔍 SEARCH
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                hintText: 'Search news...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // 📰 LIST
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: article.urlToImage,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    ),
                    title: Text(article.title),
                    subtitle: Text(article.description),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ArticleDetailScreen(article: article),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}