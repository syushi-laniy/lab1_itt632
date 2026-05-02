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
      title: 'Tesla News Malaysia',
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
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    loadNews();
  }


  Future<void> loadNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newArticles =
      await api.fetchTeslaMalaysiaNews(page: page);


      if (page == 1) {
        await cacheService.saveArticles(newArticles);
      }

      setState(() {
        page++;
        isLoading = false;
        isOffline = false;

        if (newArticles.isEmpty) {
          hasMore = false;
        } else {
          articles.addAll(newArticles);
        }
      });
    } catch (e) {

      final cached = await cacheService.getCachedArticles();

      setState(() {
        articles = cached;
        isLoading = false;
        hasMore = false;
        isOffline = true;
      });
    }
  }

  void search(String query) async {
    final result = await api.searchNews(query);

    setState(() {
      articles = result;
      hasMore = false;
      isOffline = false;
    });
  }

  void resetNews() {
    setState(() {
      articles.clear();
      page = 1;
      hasMore = true;
    });

    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tesla News (Malaysia)'),
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


          if (isOffline)
            Container(
              width: double.infinity,
              color: Colors.red,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Offline Mode - Showing cached data",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),


          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onSubmitted: search,
              decoration: InputDecoration(
                hintText: 'Search news...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),


          Expanded(
            child: ListView.builder(
              itemCount: articles.length + 1,
              itemBuilder: (context, index) {


                if (index == articles.length) {
                  if (!hasMore) return SizedBox();

                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loadNews,
                      child: isLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text("Load More"),
                    ),
                  );
                }

                final article = articles[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: article.urlToImage.isNotEmpty
                          ? article.urlToImage
                          : 'https://via.placeholder.com/150',
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