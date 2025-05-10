class MeditationSessionModel {
  final int id;
  final int? userId;
  final String title;
  final String text;
  final int duration;
  final String backgroundNoise;
  final String voice;
  final DateTime createdAt;
  final String audioUrl;

  MeditationSessionModel({
    required this.id,
    this.userId,
    required this.title,
    required this.text,
    required this.duration,
    required this.backgroundNoise,
    required this.voice,
    required this.createdAt,
    required this.audioUrl,
  });

  factory MeditationSessionModel.fromJson(Map<String, dynamic> json) {
    // pull out strings safely, defaulting if missing
    final title = (json['title'] ?? '') as String;
    final text = (json['text'] ?? '') as String;
    final duration = (json['duration'] ?? 0) as int;
    final backgroundNoise =
        (json['background_noise'] ?? json['backgroundNoise'] ?? '') as String;
    final voice = (json['voice'] ?? '') as String;
    final audioUrl = (json['audio_file'] ??
        json['audio_url'] ??
        json['audioUrl'] ??
        '') as String;

    // parse createdAt if present, otherwise use now()
    final createdAtRaw = json['created_at'] ?? json['createdAt'];
    final createdAt = createdAtRaw != null
        ? DateTime.tryParse(createdAtRaw as String) ?? DateTime.now()
        : DateTime.now();

    // userId may come as `user` or `user_id`
    final rawUser = json['user'] ?? json['user_id'];
    final userId = rawUser is int ? rawUser : null;

    return MeditationSessionModel(
      id: json['id'] as int,
      userId: userId,
      title: title,
      text: text,
      duration: duration,
      backgroundNoise: backgroundNoise,
      voice: voice,
      createdAt: createdAt,
      audioUrl: audioUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'text': text,
        'duration': duration,
        'background_noise': backgroundNoise,
        'voice': voice,
        'created_at': createdAt.toIso8601String(),
        'audio_url': audioUrl,
      };
}
