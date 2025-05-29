
import 'package:sample_project/shared/utils.dart';

abstract class IStorageService {
  String get name;

  void setInt(String key, int value);

  Future<int?> getInt(String key);

  setString(String key, String value);

  Future<String?> getString(String key);

  setJSON(String key, JSON value);

  Future<JSON?> getJSON(String key);

  setBool(String key, bool value);

  Future<bool?> getBool(String key);

  setDouble(String key, double value);

  Future<double?> getDouble(String key);

  setStringList(String key, List<String> value);

  Future<List<String>?> getStringList(String key);

  delete(String key);

  deleteAll();

  Future<bool> containsKey(String key);
}
