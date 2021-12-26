import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const DARK_THEME = 'DARK_THEME';
  static const DAILY_RESTAURANT = 'DAILY_RESTAURANT';

  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  Future<bool> get isDailyNewsActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(DAILY_RESTAURANT) ?? false;
  }

  void setDailyNews(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(DAILY_RESTAURANT, value);
  }
}
