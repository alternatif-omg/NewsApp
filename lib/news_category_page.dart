import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_model.dart';
import 'news_detail_page.dart';

class NewsCategoryPage extends StatelessWidget {
  final String source;
  final String category;

  const NewsCategoryPage({
    super.key,
    required this.source,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService('https://api-berita-indonesia.vercel.app');
    final Future<ApiResponse> categoryNewsFuture = apiService.fetchPosts(source, category);

    return Scaffold(
      appBar: AppBar(
        title: Text('News: ${category.toUpperCase()}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<ApiResponse>(
        future: categoryNewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.data.posts.isNotEmpty) {
            final posts = snapshot.data!.data.posts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final news = posts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(
                          title: news.title,
                          description: news.description,
                          link: news.link,
                          pubDate: news.pubDate,
                          thumbnail: news.thumbnail,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: news.thumbnail.isNotEmpty
                                ? Image.network(
                                    news.thumbnail,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    child: const Icon(Icons.article, size: 40, color: Colors.blueAccent),
                                  ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  news.description,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No news available.'));
          }
        },
      ),
    );
  }
}
