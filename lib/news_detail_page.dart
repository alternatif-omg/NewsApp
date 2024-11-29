import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String thumbnail;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail gambar
            if (thumbnail.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(thumbnail, fit: BoxFit.cover),
                ),
              ),

            // Ikon sosial media rata kiri
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Membuat ikon rata kiri
              children: [
                _socialMediaButton(
                  icon: Icons.facebook,
                  color: Colors.blue,
                  url: 'https://www.facebook.com',
                ),
                const SizedBox(width: 8), // Jarak antar ikon
                _socialMediaButton(
                  icon: Icons.camera_alt,
                  color: Colors.pink,
                  url: 'https://www.instagram.com',
                ),
                const SizedBox(width: 8),
                _socialMediaButton(
                  icon: Icons.message,
                  color: Colors.blueAccent,
                  url: 'https://www.twitter.com',
                ),
                const SizedBox(width: 8),
                _socialMediaButton(
                  icon: Icons.telegram,
                  color: Colors.blue,
                  url: 'https://www.telegram.org',
                ),
                const SizedBox(width: 8),
                _socialMediaButton(
                  icon: Icons.phone,
                  color: Colors.green,
                  url: 'https://www.whatsapp.com',
                ),
                const SizedBox(width: 8),
                _socialMediaButton(
                  icon: Icons.person,
                  color: Colors.blueGrey,
                  url: 'https://oauth.vk.com',
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Judul berita
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Tanggal publikasi
            Text(
              'Published on: $pubDate',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),

            // Deskripsi berita
            Text(
              description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24.0),

            // Tombol Read More
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _launchURL(link);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Read More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialMediaButton({required IconData icon, required Color color, required String url}) {
    return IconButton(
      icon: Icon(icon, color: color, size: 28), // Ukuran ikon sedikit dikurangi
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
