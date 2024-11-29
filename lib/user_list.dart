import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user_model.dart';
import 'news_detail_page.dart'; // Import halaman detail berita

class UserList extends StatefulWidget {
  final String source; // Menambahkan parameter source

  const UserList({super.key, required this.source});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<ApiResponse> futurePosts;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService('http://localhost:3000');
    futurePosts = apiService.fetchPosts(widget.source, 'terbaru');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.source.capitalize()} Posts'),
      ),
      body: FutureBuilder<ApiResponse>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final posts = snapshot.data!.data.posts;
            return GridView.count(
  crossAxisCount: 2, // Jumlah kolom dalam satu baris
  crossAxisSpacing: 8.0, // Jarak horizontal antar kartu
  mainAxisSpacing: 8.0, // Jarak vertikal antar kartu
  padding: const EdgeInsets.all(16.0),
  childAspectRatio: 3 / 4, // Rasio lebar:tinggi kartu
  children: List.generate(posts.length, (index) {
    final post = posts[index];
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail berita
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              title: post.title,
              description: post.description,
              link: post.link,
              pubDate: post.pubDate,
              thumbnail: post.thumbnail,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail gambar di atas
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: post.thumbnail.isNotEmpty
                    ? Image.network(
                        post.thumbnail,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 120,
                        color: Colors.blueAccent.withOpacity(0.2),
                        child: const Icon(Icons.image, size: 40, color: Colors.blueAccent),
                      ),
              ),
              const SizedBox(height: 8.0),

              // Judul berita
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),

              // Tanggal publikasi
              Text(
                'Published: ${post.pubDate}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }),
);



          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}

// Ekstensi untuk capitalize nama sumber
extension StringCapitalizeExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
