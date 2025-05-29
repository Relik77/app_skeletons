
import 'package:flutter/material.dart';
import 'package:sample_project/shared/models/user.model.dart';

abstract class ApplicationState extends ChangeNotifier {
  static ApplicationState? instance;
  static final Map<String, List<Function>> _listeners = {};

  static AuthUser? get authUser => instance?.currentUser;

  static set sessionid(String? value) {
    _listeners["sessionid"]?.forEach((callback) => callback(value));
  }

  static void onSessionidChanged(void Function(String? sessionid) callback) {
    _listeners.putIfAbsent("sessionid", () => []).add(callback);
  }

  static void offSessionidChanged(void Function(String? sessionid) callback) {
    _listeners["sessionid"]?.remove(callback);
  }

  static set userState(bool value) {
    _listeners["userState"]?.forEach((callback) => callback(value));
  }

  static void onUserStateChanged(void Function(bool active) callback) {
    _listeners.putIfAbsent("userState", () => []).add(callback);
  }

  static void offUserStateChanged(void Function(bool active) callback) {
    _listeners["userState"]?.remove(callback);
  }

  AuthUser? get currentUser;

  bool get isLogged => true;

  void login(AuthUser user);
  void logout();
}
