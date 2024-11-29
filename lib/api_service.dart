import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart'; // Pastikan model yang diperlukan sudah dibuat
import 'package:intl/intl.dart'; // Paket intl untuk manipulasi tanggal

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Mengambil daftar berita berdasarkan sumber dan kategori
  Future<ApiResponse> fetchPosts(String source, String category) async {
    if (source.isEmpty || category.isEmpty) {
      throw Exception('Source and category must not be empty');
    }

    final uri = Uri.parse('$baseUrl/$source/$category');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  // Mengambil notifikasi berita terbaru hanya untuk hari ini
  Future<List<Map<String, String>>> fetchNotifications() async {
    final uri = Uri.parse('https://api-berita-indonesia.vercel.app/antara/terbaru/'); // Contoh endpoint untuk berita terbaru

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['posts'] as List<dynamic>;

        // Filter berita hanya yang dipublikasikan hari ini
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final todayNotifications = data.where((item) {
          final pubDate = item['pubDate']?.toString() ?? '';
          return pubDate.startsWith(today); // Periksa apakah pubDate dimulai dengan tanggal hari ini
        }).map((item) {
          return {
            'title': item['title']?.toString() ?? 'No Title',
            'body': item['description']?.toString() ?? 'No Description',
          };
        }).toList();

        if (todayNotifications.isEmpty) {
          return [
            {
              'title': 'No News Today',
              'body': 'There are no news articles published today.'
            }
          ];
        }

        return todayNotifications;
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}
