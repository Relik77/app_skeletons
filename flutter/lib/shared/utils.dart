import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

typedef JSON<T> = Map<String, T>;

Color getContrastColor(Color color) {
  return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

Color getDarkenColor(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

Color getLightenColor(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
}

Color getGradientColor(Color min, Color max, double value) {
  final r = min.red + ((max.red - min.red) * value).round();
  final g = min.green + ((max.green - min.green) * value).round();
  final b = min.blue + ((max.blue - min.blue) * value).round();
  return Color.fromARGB(255, r, g, b);
}

Color colorFromRGBAString({required String color}) {
  if (color.indexOf("#") == 0) {
    color = color.substring(1);
    if (color.length <= 4) {
      String r = color.substring(0, 1);
      String g = color.substring(1, 2);
      String b = color.substring(2, 3);
      String a = "f";
      if (color.length == 4) {
        a = color.substring(3, 4);
      }
      color = "$a$a$r$r$g$g$b$b";
    } else {
      if (color.length == 6) {
        color = "ff$color";
      } else if (color.length == 8) {
        color = color.substring(6) + color.substring(0, 6);
      }
    }
    color = "0x$color";
  }
  if (!color.contains("0x")) {
    return Colors.purpleAccent;
  }
  return Color(int.parse(color));
}

String colorToRGBAString({required Color color}) {
  String r = (color.red > 16 ? "" : "0") + color.red.toRadixString(16);
  String g = (color.green > 16 ? "" : "0") + color.green.toRadixString(16);
  String b = (color.blue > 16 ? "" : "0") + color.blue.toRadixString(16);
  String a = (color.alpha > 16 ? "" : "0") + color.alpha.toRadixString(16);
  return "#$r$g$b$a".toUpperCase();
}

String colorToRGBString({required Color color}) {
  String r = (color.red > 16 ? "" : "0") + color.red.toRadixString(16);
  String g = (color.green > 16 ? "" : "0") + color.green.toRadixString(16);
  String b = (color.blue > 16 ? "" : "0") + color.blue.toRadixString(16);
  return "#$r$g$b".toUpperCase();
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(email.trim());
}

bool isValidPhone(String phone) {
  return RegExp(r"^(0|\+33)[1-9]([-. ]?[0-9]{2}){4}$").hasMatch(phone.trim());
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}

bool isSameYear(DateTime date1, DateTime date2) {
  return date1.year == date2.year;
}

DateTime minDate(List<DateTime> dates) {
  return dates.reduce((value, element) => value.isBefore(element) ? value : element);
}

DateTime maxDate(List<DateTime> dates) {
  return dates.reduce((value, element) => value.isAfter(element) ? value : element);
}

String capitalize(String text) {
  return text.substring(0, 1).toUpperCase() + text.substring(1);
}

bool isTrue(
    dynamic value, {
      bool defaultValue = false,
    }) {
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value == 1;
  }
  if (value is String) {
    if (value.isEmpty) {
      return defaultValue;
    }
    return value == '1' || value.toLowerCase() == 'true';
  }
  return defaultValue;
}

String buildPath(String url, Map<String, String?>? params) {
  String newUrl = url;
  if (params != null) {
    params.forEach((key, value) {
      value ??= '';
      newUrl = newUrl.replaceFirst(RegExp('{\\s*$key\\s*}'), value);
    });
  }
  return newUrl.replaceAll(RegExp(r'/+$'), '');
}

void openURL({required String url}) async {
  await launchUrlString(url, mode: LaunchMode.externalApplication);
}

class Pair<K, V> {
  final K first;
  final V second;

  Pair(this.first, this.second);
}

class MaterialColorGenerator {
  static MaterialColor from(
      Color color, {
        bool reverse = false,
        Map<int, Color> swatch = const {},
      }) {
    if (!reverse) {
      return MaterialColor(color.value, {
        50: swatch[50] ?? tintColor(color, 0.9),
        100: swatch[100] ?? tintColor(color, 0.8),
        200: swatch[200] ?? tintColor(color, 0.6),
        300: swatch[300] ?? tintColor(color, 0.4),
        400: swatch[400] ?? tintColor(color, 0.2),
        500: swatch[500] ?? color,
        600: swatch[600] ?? shadeColor(color, 0.1),
        700: swatch[700] ?? shadeColor(color, 0.2),
        800: swatch[800] ?? shadeColor(color, 0.3),
        900: swatch[900] ?? shadeColor(color, 0.4),
      });
    } else {
      return MaterialColor(color.value, {
        50: swatch[50] ?? shadeColor(color, 0.9),
        100: swatch[100] ?? shadeColor(color, 0.8),
        200: swatch[200] ?? shadeColor(color, 0.6),
        300: swatch[300] ?? shadeColor(color, 0.4),
        400: swatch[400] ?? shadeColor(color, 0.2),
        500: swatch[500] ?? color,
        600: swatch[600] ?? tintColor(color, 0.1),
        700: swatch[700] ?? tintColor(color, 0.2),
        800: swatch[800] ?? tintColor(color, 0.3),
        900: swatch[900] ?? tintColor(color, 0.4),
      });
    }
  }

  static int tintValue(int value, double factor) => max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) =>
      Color.fromRGBO(tintValue(color.red, factor), tintValue(color.green, factor), tintValue(color.blue, factor), 1);

  static int shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) =>
      Color.fromRGBO(shadeValue(color.red, factor), shadeValue(color.green, factor), shadeValue(color.blue, factor), 1);
}
