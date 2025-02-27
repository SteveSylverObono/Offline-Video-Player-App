import 'package:shared_preferences/shared_preferences.dart';

class CustomSharePreference {
  Future<void> deletePreference(String ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(ref);
  }

  Future<void> saveSharepreference(String key, String? ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (ref != null) {
      await prefs.setString(key, ref);
    } else {
      // Handle the case where ref is null, maybe log an error or throw an exception
      throw ArgumentError('Reference cannot be null');
    }
  }

  Future<String?> getPreferenceValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
