class ReviewModel {
  final String? id;
  final String userName;
  final String date;
  final String comment;
  final double rating;
  int likes;
  bool isLikedByMe;

  ReviewModel({
    this.id,
    required this.userName,
    required this.date,
    required this.comment,
    required this.rating,
    this.likes = 0,
    this.isLikedByMe = false,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString(),
      userName: json['users']?['name'] ?? 'Usuario Petitt',
      date: json['created_at']?.toString().split('T')[0] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(String userId, String productId) => {
    'user_id': userId,
    'product_id': productId,
    'rating': rating,
    'comment': comment,
  };
}
