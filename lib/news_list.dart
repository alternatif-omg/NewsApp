import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_model.dart';
import 'dart:async';
import 'news_detail_page.dart';
import 'news_category_page.dart';
import 'dart:math';



class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late Future<ApiResponse> latestNewsFuture;
  late Future<ApiResponse> recommendedNewsFuture;
  String selectedSource = 'antara'; // Default sumber berita
  String selectedCategory = 'terbaru'; // Default kategori berita
  String userName = "Alfan Huda";
  String avatarImagePath = 'assets/avatar.jpg';
  final ApiService apiService = ApiService('https://api-berita-indonesia.vercel.app');
  final PageController categoryPageController = PageController();
  int currentPage = 0;


  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  @override
  void dispose() {
    categoryPageController.dispose();
    super.dispose();
  }

  void _fetchNews() {
    setState(() {
      latestNewsFuture = apiService.fetchPosts(selectedSource, selectedCategory);
      recommendedNewsFuture = apiService.fetchPosts(selectedSource, 'terbaru');

       // Pilih kategori random untuk vertikal selain "terbaru"
    final categories = _categories[selectedSource]
        ?.where((category) => category['name'] != 'terbaru')
        .toList();

    if (categories != null && categories.isNotEmpty) {
      final random = Random();
      final randomCategory = categories[random.nextInt(categories.length)]['path'];
      latestNewsFuture = apiService.fetchPosts(selectedSource, randomCategory!);
    } else {
      // Fallback jika tidak ada kategori selain "terbaru"
      
    }
  });
}
      
 
void _searchNews(String query) {
  setState(() {
    latestNewsFuture = apiService.fetchPosts(selectedSource, 'search?q=$query'); // Contoh endpoint pencarian
  });
}

void _searchNewsOffline(String query) {
  setState(() {
    latestNewsFuture = latestNewsFuture.then((response) {
      final filteredPosts = response.data.posts
          .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return ApiResponse(
        success: response.success,
        message: response.message,
        data: DataResponse(
          link: response.data.link,
          image: response.data.image,
          description: response.data.description,
          title: response.data.title,
          posts: filteredPosts,
        ),
      );
    });
  });
}



  @override
  Widget build(BuildContext context) {
    final ScrollController horizontalScrollController = ScrollController();

    
       return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User Info
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 24.0, // Ukuran lingkaran
                      backgroundImage: AssetImage(avatarImagePath), // Gambar avatar
                      backgroundColor: Colors.grey[200], // Background jika gambar tidak ditemukan
                    ),
                    const SizedBox(width: 12.0), // Jarak antara avatar dan teks
                    // User Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $userName!',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Jelajahi berita terkini untuk Anda',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Notifications Icon
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.grey,
                    size: 28.0,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications'); // Navigasi ke halaman notifikasi
                  },
                ),
              ],
            ),
          ),



          // Scroll horizontal untuk daftar sumber berita
          SizedBox(
  height: 100.0,
  child: ListView.builder(
    controller: horizontalScrollController,
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
    itemCount: _newsSources.length,
    itemBuilder: (context, index) {
      final source = _newsSources[index];
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedSource = source['key'];
            selectedCategory = 'terbaru'; // Default kategori
          });
          _fetchNews();
        },
        child: Container(
          width: 100.0,
          margin: const EdgeInsets.only(right: 16.0),
          decoration: BoxDecoration(
            color: selectedSource == source['key']
                ? Colors.blueAccent
                : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                source['icon'], // Ganti Icon dengan Image.asset
                height: 40.0,
                width: 40.0,
                fit: BoxFit.contain,
              ),
                  
              const SizedBox(height: 8.0),
              Text(
                source['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: selectedSource == source['key']
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),





// TextField untuk pencarian
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: TextField(
    decoration: InputDecoration(
      hintText: 'Cari berita...',
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
    onSubmitted: (query) {
      _searchNews(query); // Fungsi pencarian
    },
  ),
),

// Label "Rekomendasi"
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  child: Text(
    'Rekomendasi',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.blueAccent,
    ),
  ),
),
FutureBuilder<ApiResponse>(
  future: recommendedNewsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData && snapshot.data!.data.posts.isNotEmpty) {
      final posts = snapshot.data!.data.posts;

      // PageController untuk animasi geser
      final PageController pageController = PageController();

      Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        if (pageController.hasClients) {
          final nextPage = (pageController.page ?? 0).toInt() + 1;
          if (nextPage < (posts.length / 2).ceil()) {
            pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });

      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: pageController,
              itemCount: (posts.length / 2).ceil(), // Menampilkan 2 berita per halaman
              itemBuilder: (context, index) {
                final firstNews = posts[index * 2];
                final secondNews =
                    (index * 2 + 1 < posts.length) ? posts[index * 2 + 1] : null;

                return Row(
                  children: [
                    // Berita Pertama
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(
                                title: firstNews.title,
                                description: firstNews.description,
                                link: firstNews.link,
                                pubDate: firstNews.pubDate,
                                thumbnail: firstNews.thumbnail,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: firstNews.thumbnail.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(firstNews.thumbnail),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  firstNews.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Berita Kedua (jika ada)
                    if (secondNews != null)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailPage(
                                  title: secondNews.title,
                                  description: secondNews.description,
                                  link: secondNews.link,
                                  pubDate: secondNews.pubDate,
                                  thumbnail: secondNews.thumbnail,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: secondNews.thumbnail.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(secondNews.thumbnail),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    secondNews.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          // Tombol Geser Kiri
          Positioned(
            left: 16.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                if (pageController.hasClients) {
                  final previousPage = (pageController.page ?? 0).toInt() - 1;
                  if (previousPage >= 0) {
                    pageController.animateToPage(
                      previousPage,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
            ),
          ),
          // Tombol Geser Kanan
          Positioned(
            right: 16.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              onPressed: () {
                if (pageController.hasClients) {
                  final nextPage = (pageController.page ?? 0).toInt() + 1;
                  if (nextPage < (posts.length / 2).ceil()) {
                    pageController.animateToPage(
                      nextPage,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
            ),
          ),
        ],
      );
    } else {
      return const Center(child: Text('No recommendations available.'));
    }
  },
),



         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: SizedBox(
    height: 35.0, // Atur tinggi scrollable button
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // Scroll ke arah horizontal
      itemCount: _categories[selectedSource]?.length ?? 0,
      itemBuilder: (context, index) {
        final category = _categories[selectedSource]?[index];
        final isSelected = selectedCategory == category?['name'];
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category?['name'] ?? '';
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsCategoryPage(
                  source: selectedSource,
                  category: category?['name'] ?? '',
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.transparent, // Warna tombol saat dipilih
              border: Border.all(
                color: Colors.blueAccent, // Border biru
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                category?['name']?.toUpperCase() ?? '',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.blueAccent, // Warna teks
                ),
              ),
            ),
          ),
        );
      },
    ),
  ),
),



          const SizedBox(height: 10.0),

          // Daftar berita terbaru
          Expanded(
            child: FutureBuilder<ApiResponse>(
              future: latestNewsFuture,
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
                                // Thumbnail Gambar
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
                                          child: const Icon(Icons.article,
                                              size: 40, color: Colors.blueAccent),
                                        ),
                                ),
                                const SizedBox(width: 12.0),
                                // Informasi Artikel
                                
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
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Data untuk news sources
const List<Map<String, dynamic>> _newsSources = [
  {'name': 'Antara', 'key': 'antara', 'icon': 'assets/antara.jpg'},

  {'name': 'CNN', 'key': 'cnn', 'icon': 'assets/cnn.png'},
  {'name': 'Republika', 'key': 'republika', 'icon': 'assets/republika.jpg'},
  {'name': 'Sindonews', 'key': 'sindonews', 'icon': 'assets/sindo.jpg'},
 
];


// Data untuk kategori berita
const Map<String, List<Map<String, String>>> _categories = {
  'antara': [
    {'name': 'terbaru', 'path': 'terbaru'},
    {'name': 'ekonomi', 'path': 'ekonomi'},
    
    {'name': 'politik', 'path': 'politik'},
    
    {'name': 'bola', 'path': 'bola'},
    {'name': 'olahraga', 'path': 'olahraga'},
   
    {'name': 'lifestyle', 'path': 'lifestyle'},

  ],
  
  'cnn': [
     {'name': 'terbaru', 'path': 'terbaru'},
    {'name': 'internasional', 'path': 'internasional'},
   
    {'name': 'nasional', 'path': 'nasional'},
    {'name': 'ekonomi', 'path': 'ekonomi'},
    {'name': 'olahraga', 'path': 'olahraga'},
    
  ],
  'republika': [
     {'name': 'terbaru', 'path': 'terbaru'},
    {'name': 'khazanah', 'path': 'khazanah'},
   {'name': 'international', 'path': 'international'},
   {'name': 'bola', 'path': 'bola'},
   {'name': 'leisure', 'path': 'leisure'},
    {'name': 'islam', 'path': 'islam'},
    
  ],
  'sindonews': [
     {'name': 'terbaru', 'path': 'terbaru'},
    {'name': 'nasional', 'path': 'nasional'},
   {'name': 'metro', 'path': 'metro'},
   {'name': 'international', 'path': 'international'},
   {'name': 'daerah', 'path': 'daerah'},
    
    
  ],
  // Tambahkan kategori lainnya
};
