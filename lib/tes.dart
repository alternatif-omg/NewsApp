import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> fetchPosts(String source, String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$source/$category'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Ambil data dari kunci 'posts'
        final posts = jsonResponse['posts'] ?? [];
        
        // Debug: Cek isi posts
        print('Posts: $posts');
        
        return posts; // Mengembalikan daftar posts
      } else {
        print('Error: ${response.statusCode}'); // Debug: Tampilkan status error
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e'); // Debug: Tampilkan exception
      throw Exception('Failed to load data: $e');
    }
  }
}

class TesPage extends StatefulWidget {
  final String source;

  const TesPage({super.key, required this.source});

  @override
  _TesPageState createState() => _TesPageState();
}

class _TesPageState extends State<TesPage> {
  late Future<List<dynamic>> futurePosts;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService('http://localhost:3000');
    futurePosts = apiService.fetchPosts(widget.source, 'terbaru');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data from ${widget.source}'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 2,
                child: ListTile(
                  leading: post['thumbnail'] != null
                      ? Image.network(post['thumbnail'], width: 100, fit: BoxFit.cover)
                      : null,
                  title: Text(post['title'] ?? 'No title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['description'] ?? 'No description'),
                      Text('Published on: ${post['pubDate'] ?? 'No date'}'),
                    ],
                  ),
                  onTap: () {
                    // Anda bisa menambahkan aksi saat berita diklik
                    if (post['link'] != null) {
                      // Buka link berita
                      // gunakan package url_launcher untuk membuka link di browser
                      // launch(post['link']);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TesPage(source: 'antara'), // Ganti 'antara' sesuai sumber yang diinginkan
  ));
}
