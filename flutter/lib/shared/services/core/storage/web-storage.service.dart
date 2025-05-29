import 'dart:convert';

import 'package:sample_project/shared/services/core/storage/storage.interface.service.dart';
import 'package:sample_project/shared/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebStorageService implements IStorageService {
  @override
  String get name => 'web-storage';

  @override
  setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  setJSON(String key, JSON value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }

  @override
  Future<JSON?> getJSON(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    try {
      return value != null ? jsonDecode(value) : null;
    } catch (e) {
      /// If the value is not a valid JSON, return null
      return null;
    }
  }

  @override
  setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  @override
  setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  @override
  setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  @override
  delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  @override
  deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> has(String key) async {
    return containsKey(key);
  }
}
