import 'package:flutter/material.dart';
import 'news_list.dart'; // Halaman utama untuk daftar berita
import 'notification_page.dart'; // Halaman notifikasi

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Rute awal aplikasi
      routes: {
        '/': (context) => const NewsList(), // Halaman utama aplikasi
        '/notifications': (context) => const NotificationPage(), // Halaman notifikasi
      },
    );
  }
}
