/// CAPA DE DOMINIO - Modelo
/// Representa una reseña de producto escrita por un usuario.
class ReviewModel {
  final String userName;
  final String date;
  final String comment;
  final double rating;
  int likes;
  bool isLikedByMe;

  ReviewModel({
    required this.userName,
    required this.date,
    required this.comment,
    required this.rating,
    this.likes = 0,
    this.isLikedByMe = false,
  });

  Map<String, dynamic> toJson() => {
        'user_name': userName,
        'date': date,
        'comment': comment,
        'rating': rating,
        'likes': likes,
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        userName: json['user_name'] as String? ?? 'Usuario',
        date: json['date'] as String? ?? '',
        comment: json['comment'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        likes: json['likes'] as int? ?? 0,
      );
}

