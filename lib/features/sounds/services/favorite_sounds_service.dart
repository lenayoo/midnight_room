import 'package:shared_preferences/shared_preferences.dart';

class FavoriteSoundsService {
  const FavoriteSoundsService();

  static const String favoriteSoundIdsKey = 'favorite_sound_ids';

  Future<Set<String>> loadFavoriteSoundIds() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> storedIds =
        preferences.getStringList(favoriteSoundIdsKey) ?? const <String>[];

    return storedIds
        .map((String id) => id.trim())
        .where((String id) => id.isNotEmpty)
        .toSet();
  }

  Future<void> saveFavoriteSoundIds(Set<String> soundIds) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> sortedIds = soundIds.toList()..sort();
    await preferences.setStringList(favoriteSoundIdsKey, sortedIds);
  }
}
