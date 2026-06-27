import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  const UserProfileService();

  static const String userNameKey = 'user_name';

  Future<String?> loadUserName() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? storedName = preferences.getString(userNameKey)?.trim();

    if (storedName == null || storedName.isEmpty) {
      return null;
    }

    return storedName;
  }

  Future<void> saveUserName(String userName) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(userNameKey, userName.trim());
  }
}
