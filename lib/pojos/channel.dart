class Channel {
  final int channelId;
  final int creatorId;
  final String creatorName;
  final String creatorLastName;
  final String name;
  final String description;

  const Channel({
    required this.channelId,
    required this.creatorId,
    required this.creatorName,
    required this.creatorLastName,
    required this.name,
    required this.description,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'channel_id': int channelId,
        'creator_id': int creatorId,
        'creator_name': String creatorName,
        'creator_last_name': String creatorLastName,
        'name': String name,
        'description': String description,
      } =>
        Channel(
          channelId: channelId,
          creatorId: creatorId,
          creatorName: creatorName,
          creatorLastName: creatorLastName,
          name: name,
          description: description,
        ),
      _ => throw const FormatException('Failed to load channels.'),
    };
  }
}