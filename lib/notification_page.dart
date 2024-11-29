import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart'; // Import untuk memformat tanggal dan waktu

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService('https://your-api-url.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // Ubah ke dynamic untuk dukung waktu
        future: apiService.fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final timestamp = notification['timestamp']; // Ambil waktu dari notifikasi
                final formattedTime = timestamp != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(timestamp))
                    : 'Unknown Time';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(notification['title'] ?? 'No Title'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification['body'] ?? 'No Description'),
                        const SizedBox(height: 4.0),
                        Text(
                          'Time: $formattedTime',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    leading: const Icon(Icons.notifications, color: Colors.blueAccent),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No notifications available.'),
            );
          }
        },
      ),
    );
  }
}
