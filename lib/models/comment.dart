class Comment {
  final int commentId;
  final int postId;
  final int userId;
  final String comment;
  final String publishDate;
  final int rating;

  const Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.comment,
    required this.publishDate,
    required this.rating,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      postId: json['post_id'],
      userId: json['user_id'],
      comment: json['comment'],
      publishDate: json['publish_date'],
      rating: json['rating'],
    );
  }
}
