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
}
