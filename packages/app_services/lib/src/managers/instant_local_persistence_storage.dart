abstract class InstantLocalPersistenceService {
  Future<void> setBool(String key, bool value);
  Future<bool> getBool(String key, bool defaultValue);
  Future<bool?> getBoolValue(String key);

  Future<void> setString(String key, String value);
  Future<String?> getString(String key, {String? defaultValue});

  Future<void> setInt(String key, int value);
  Future<int> getInt(String key, int defaultValue);
  Future<int?> getIntValue(String key);

  Future<void> setStringList(String key, List<String> value);
  Future<List<String>> getStringList(String key, List<String> defaultList);
  Future<List<String>?> getStringListValue(String key);

  Future<void> setDouble(String key, double value);
  Future<double> getDouble(String key, double defaultValue);
  Future<double?> getDoubleValue(String key);

  Future<void> remove(String key);
  Future<bool> clear();
}
