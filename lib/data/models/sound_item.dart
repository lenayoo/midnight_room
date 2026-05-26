class SoundItem {
  const SoundItem({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.imagePath,
    required this.audioPath,
    required this.isPremium,
    required this.isFavorite,
    this.moodTags = const <String>[],
  });

  final String id;
  final String title;
  final String category;
  final String duration;
  final String imagePath;
  final String audioPath;
  final bool isPremium;
  final bool isFavorite;
  final List<String> moodTags;

  SoundItem copyWith({
    String? id,
    String? title,
    String? category,
    String? duration,
    String? imagePath,
    String? audioPath,
    bool? isPremium,
    bool? isFavorite,
    List<String>? moodTags,
  }) {
    return SoundItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      isPremium: isPremium ?? this.isPremium,
      isFavorite: isFavorite ?? this.isFavorite,
      moodTags: moodTags ?? this.moodTags,
    );
  }
}
