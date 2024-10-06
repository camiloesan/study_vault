class Post {
  final int postId;
  final int channelId;
  final int fileId;
  final String title;
  final String description;
  final String publishDate;

  const Post({
    required this.postId,
    required this.channelId,
    required this.fileId,
    required this.title,
    required this.description,
    required this.publishDate,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'post_id': int postId,
        'channel_id': int channelId,
        'file_id': int fileId,
        'title': String title,
        'description': String description,
        'publish_date': String publishDate,
      } =>
        Post(
          postId: postId,
          channelId: channelId,
          fileId: fileId,
          title: title,
          description: description,
          publishDate: publishDate,
        ),
      _ => throw const FormatException('Failed to load channels.'),
    };
  }
}