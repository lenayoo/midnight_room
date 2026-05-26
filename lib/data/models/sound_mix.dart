class SoundMix {
  const SoundMix({
    required this.id,
    required this.title,
    required this.layers,
    required this.createdAt,
    required this.isPremium,
  });

  final String id;
  final String title;
  final List<String> layers;
  final DateTime createdAt;
  final bool isPremium;
}
