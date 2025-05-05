class MeditationSessionModel {
  final int id;
  final int userId;
  final String title;
  final String text;
  final int duration;
  final String backgroundNoise;
  final String voice;
  final DateTime createdAt;
  final String? audioFile; // matches your `audio_file` URL

  MeditationSessionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.text,
    required this.duration,
    required this.backgroundNoise,
    required this.voice,
    required this.createdAt,
    this.audioFile,
  });

  factory MeditationSessionModel.fromJson(Map<String, dynamic> json) {
    return MeditationSessionModel(
      id: json['id'] as int,
      userId: json['user'] as int,
      title: json['title'] as String,
      text: (json['text'] as String?) ?? '',
      duration: json['duration'] as int,
      backgroundNoise: (json['background_noise'] as String?) ?? '',
      voice: (json['voice'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      audioFile: json['audio_file'] as String?, // nullable
    );
  }
}
