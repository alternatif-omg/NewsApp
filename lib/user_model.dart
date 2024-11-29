// Class representing a single Post
class Post {
  final String link;
  final String title;
  final String pubDate;
  final String description;
  final String thumbnail;

  // Constructor for Post class
  Post({
    required this.link,
    required this.title,
    required this.pubDate,
    required this.description,
    required this.thumbnail,
  });

  // Factory constructor to create a Post instance from a JSON object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      link: json['link'] ?? '', // Handle possible null values
      title: json['title'] ?? 'No Title',
      pubDate: json['pubDate'] ?? 'No Date',
      description: json['description'] ?? 'No Description',
      thumbnail: json['thumbnail'] ?? '', // Empty if not provided
    );
  }
}

// Class representing the response data that includes a list of posts
class DataResponse {
  final String link;
  final String image;
  final String description;
  final String title;
  final List<Post> posts;

  // Constructor for DataResponse class
  DataResponse({
    required this.link,
    required this.image,
    required this.description,
    required this.title,
    required this.posts,
  });

  // Factory constructor to create a DataResponse instance from a JSON object
  factory DataResponse.fromJson(Map<String, dynamic> json) {
    var postsFromJson = json['posts'] as List? ?? [];
    List<Post> postsList = postsFromJson.map((i) => Post.fromJson(i)).toList();

    return DataResponse(
      link: json['link'] ?? '', // Provide default value if null
      image: json['image'] ?? '', // Provide default value if null
      description: json['description'] ?? 'No Description',
      title: json['title'] ?? 'No Title',
      posts: postsList,
    );
  }
}

// Class representing the overall API response
class ApiResponse {
  final bool success;
  final String? message; // Message is optional, can be null
  final DataResponse data;

  // Constructor for ApiResponse class
  ApiResponse({
    required this.success,
    this.message, // Optional field
    required this.data,
  });

  // Factory constructor to create an ApiResponse instance from a JSON object
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false, // Default to false if null
      message: json['message'], // This can be null, no default value needed
      data: DataResponse.fromJson(json['data'] ?? {}), // Provide an empty map if data is null
    );
  }
}
