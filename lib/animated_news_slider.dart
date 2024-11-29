import 'dart:async';
import 'package:flutter/material.dart';
import 'news_detail_page.dart';
import 'user_model.dart'; // Import jika diperlukan untuk model ApiResponse

class AnimatedNewsSlider extends StatefulWidget {
  final Future<ApiResponse> future;

  const AnimatedNewsSlider({super.key, required this.future});

  @override
  _AnimatedNewsSliderState createState() => _AnimatedNewsSliderState();
}

class _AnimatedNewsSliderState extends State<AnimatedNewsSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Timer untuk animasi geser otomatis
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage++;
          if (_currentPage >= (widget.future as List).length) {
            _currentPage = 0;
          }
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.data.posts.isNotEmpty) {
          final posts = snapshot.data!.data.posts;
          return SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: news.thumbnail.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(news.thumbnail),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            news.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No recommendations available.'));
        }
      },
    );
  }
}
