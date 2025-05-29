import 'package:flutter/material.dart';

abstract class ITheme {
  String get name;
  ThemeData get light;
  ThemeData get dark;
}
