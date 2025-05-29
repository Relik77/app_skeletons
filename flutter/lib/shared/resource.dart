import 'package:flutter/foundation.dart';

const bool enableDebug = false;

abstract class Resource {
  static const bool debug = kDebugMode ? enableDebug : false;
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const isProd = env == 'prod';
  static const buildDate = String.fromEnvironment('BUILD_DATE', defaultValue: '2021-01-01 00:00:00');
  static const buildVersion = String.fromEnvironment('BUILD_VERSION', defaultValue: '0.0.0');
  static const appIcon = "assets/img/app_icon.png";
  static const appLogo = "assets/img/app_logo.png";
  static const String imageAvatar = "assets/img/avatar.jpg";
}
