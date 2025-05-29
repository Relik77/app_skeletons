
import 'package:flutter/material.dart';
import 'package:sample_project/shared/utils.dart';
import 'package:sample_project/ui/navigation/navigation_path.dart';

class FormValues {
  final String formName;
  final JSON _data;

  JSON get data => _data;

  FormValues({
    required this.formName,
    required JSON data,
  }) : _data = data;

  JSON toJson() {
    return {
      "formName": formName,
      "data": data,
    };
  }
}

abstract class NavigationState extends ChangeNotifier {
  static NavigationState? instance;

  static const pages = {
    "home": null,
    "register": null,
    "login": null,
    "lostpassword": null,
    "account": null,
  };

  static const homePage = 1;
  static const registerPage = 1 << 1;
  static const loginPage = 1 << 2;
  static const lostPasswordPage = 1 << 3;
  static const accountPage = 1 << 4;

  int get stack;
  int get lastPage;
  int get historyLength;

  String? get currentTab;
  set currentTab(String? value);

  FormValues? get formValues;

  NavigationPage get currentPage {
    switch (lastPage) {
      case homePage:
        return NavigationPage(
          name: "home",
        );
      default:
        return NavigationPage(
          name: "home",
        );
    }
  }

  bool show(int page) => stack & page != 0;

  void back();
  void home();
  void register();
  void login();
  void lostPassword();
  void account();
}