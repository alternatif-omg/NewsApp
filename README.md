# Project Aplikasi Berita - Asynchronous Programming

Project ini adalah sebuah aplikasi berita yang dibangun dengan Flutter dan menggunakan pemrograman asinkron untuk mengambil dan menampilkan data berita secara dinamis. Aplikasi ini mengandalkan API untuk mengambil data berita berdasarkan kategori dan sumber, dengan proses pengambilan data yang dilakukan secara asinkron. Aplikasi ini dibangun menggunakan Flutter dan mengandalkan beberapa file untuk mengatur logika dan tampilan.

## Struktur File

<img src="https://github.com/user-attachments/assets/6c2ee47a-305c-4405-8701-dac7f3064a6f" width="200"/>

### 1. **`api_service.dart`**
Menyediakan berbagai metode untuk mengambil data dari API, seperti mengambil daftar berita berdasarkan sumber dan kategori, serta mengelola permintaan HTTP. File ini juga menangani error handling dan pemrosesan respons dari server.

### 2. **`main.dart`**
File yang bertanggung jawab untuk menginisialisasi aplikasi Flutter, menyiapkan struktur dasar dengan `MaterialApp`, dan mengatur navigasi antara halaman-halaman dalam aplikasi (seperti halaman daftar berita dan notifikasi).

### 3. **`news_list.dart`**
Halaman utama untuk menampilkan berita berdasarkan sumbernya, yang berisi header, pencarian, notifikasi, dan berita rekomendasi.
   
<img src="https://github.com/user-attachments/assets/0f46a960-8139-4aca-9cda-d56088545e6a" width="300"/>

### 4. **`news_category_page.dart`**
Menampilkan daftar berita berdasarkan kategori yang dipilih oleh pengguna. Pengguna dapat memilih kategori tertentu untuk melihat daftar artikel berita yang relevan.

<img src="https://github.com/user-attachments/assets/d66d6056-82ed-44ca-9e9c-72bfb9c4e5a0" width="300"/>

### 5. **`news_detail_page.dart`**
Menampilkan detail dari artikel berita yang dipilih. Halaman ini memuat informasi lengkap mengenai judul berita, deskripsi, gambar, dan link ke halaman sumber berita.

<img src="https://github.com/user-attachments/assets/66855fc5-3da3-41a9-819b-b20d8c4c6f4c" width="300"/>

### 6. **`notification_page.dart`**
Halaman untuk menampilkan notifikasi berita terbaru berdasarkan tanggal publikasi hari ini. Aplikasi akan memeriksa artikel berita yang dipublikasikan pada hari yang sama dan menampilkan informasi tersebut kepada pengguna.

### 7. **`user_list.dart`**
Mengambil daftar berita dari API berdasarkan sumber yang diberikan. Menangani pemuatan data dari API dengan menggunakan `FutureBuilder` dan menampilkan `CircularProgressIndicator` selama proses pemuatan.

### 8. **`user_model.dart`**
Berisi kelas untuk model data pengguna jika aplikasi memerlukan informasi pengguna untuk berinteraksi lebih lanjut dengan API atau backend.

## Asset
Aplikasi ini menggunakan beberapa asset untuk menampilkan logo tiap sumber berita dan avatar pengguna. Berikut adalah contoh asset yang digunakan:

<img src="https://github.com/user-attachments/assets/3f02ef0a-9a7c-4806-b1f9-d49735524ad1" width="200"/>

## Referensi API
Dokumentasi JSON API dan URL endpoint yang digunakan di program dapat diakses di:
[API Dokumentasi](https://github.com/renomureza/api-berita-indonesia.git)
