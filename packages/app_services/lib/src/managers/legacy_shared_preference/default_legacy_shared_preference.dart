import 'package:app_services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultLegacySharedPreference implements InstantLocalPersistenceService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<bool> clear() async {
    final pref = await _prefs;
    return pref.clear();
  }

  @override
  Future<double> getDouble(String key, double defaultValue) async {
    final pref = await _prefs;
    return pref.getDouble(key) ?? defaultValue;
  }

  @override
  Future<int> getInt(String key, int defaultValue) async {
    final pref = await _prefs;
    return pref.getInt(key) ?? defaultValue;
  }

  @override
  Future<String?> getString(String key, {String? defaultValue}) async {
    final pref = await _prefs;
    return pref.getString(key) ?? defaultValue;
  }

  @override
  Future<List<String>> getStringList(String key, List<String> defaultList) async {
    final pref = await _prefs;
    return pref.getStringList(key) ?? defaultList;
  }

  @override
  Future<void> remove(String key) async {
    final pref = await _prefs;
    await pref.remove(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    final pref = await _prefs;
    await pref.setBool(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    final pref = await _prefs;
    await pref.setDouble(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final pref = await _prefs;
    await pref.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String value) async {
    final pref = await _prefs;
    await pref.setString(key, value);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    final pref = await _prefs;
    await pref.remove(key);
  }

  @override
  Future<bool?> getBoolValue(String key) async {
    final pref = await _prefs;
    return pref.getBool(key);
  }

  @override
  Future<double?> getDoubleValue(String key) async {
    final pref = await _prefs;
    return pref.getDouble(key);
  }

  @override
  Future<int?> getIntValue(String key) async {
    final pref = await _prefs;
    return pref.getInt(key);
  }

  @override
  Future<List<String>?> getStringListValue(String key) async {
    final pref = await _prefs;
    return pref.getStringList(key);
  }

  @override
  Future<bool> getBool(String key, bool defaultValue) async {
    final pref = await _prefs;
    return pref.getBool(key) ?? defaultValue;
  }
}
