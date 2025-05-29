

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_project/shared/utils.dart';
import 'package:sample_project/themes/app_theme.dart';
import 'package:sample_project/themes/theme.interface.dart';
import 'package:sample_project/ui/navigation/page_transitions.dart';

class DefaultTheme extends ITheme {
  static const fontFamily = "Roboto";

  static final _appTheme = AppTheme(
    fontFamily: fontFamily,
    textColor: MaterialColorGenerator.from(const Color(0xFF000000), swatch: {
      50: const Color(0xFFF6F6F6),
      100: const Color(0xFFEEEEEE),
      200: const Color(0xFFB2B2B2),
      300: const Color(0xFF777777),
      400: const Color(0xFF3B3B3B),
      500: const Color(0xFF000000),
    }),
    primary: MaterialColorGenerator.from(const Color(0xFF6da0e0), swatch: {
      100: const Color(0xFFdde9ff),
      200: const Color(0xFFc5dbff),
      500: const Color(0xFF6da0e0),
      800: const Color(0xFF1960A5),
    }),
    secondary: MaterialColorGenerator.from(const Color(0xFF3d2c84)),
    accent: MaterialColorGenerator.from(const Color(0xFFcb0065)),
    success: MaterialColorGenerator.from(const Color(0xFF5db891), swatch: {
      100: const Color(0xFFdff1e9),
      200: const Color(0xFFbfe3d3),
    }),
    danger: MaterialColorGenerator.from(const Color(0xFFbb0b0b)),
    warning: MaterialColorGenerator.from(const Color(0xFFf2b707)),
    info: MaterialColorGenerator.from(const Color(0xFF0b7abb)),
    sidebar: MaterialColorGenerator.from(const Color(0xFF303030), swatch: {
      50: Colors.white,
    }),
    cardBorderRadius: BorderRadius.circular(8),
  );

  @override
  String get name => "Default";

  TextTheme getTextTheme(AppTheme appTheme, {required Brightness brightness}) {
    TextTheme? textTheme;
    try {
      textTheme = GoogleFonts.getTextTheme(appTheme.fontFamily);
    } catch (e) {
      // font not found
    }
    textTheme = textTheme ?? (brightness == Brightness.light ? ThemeData.light() : ThemeData.dark()).textTheme;
    textTheme = textTheme.apply(
      fontFamily: appTheme.fontFamily,
      displayColor: appTheme.textColor,
      bodyColor: appTheme.textColor,
    );
    textTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge!.copyWith(
        fontFamily: fontFamily,
        fontSize: 57,
      ),
      displayMedium: textTheme.displayMedium!.copyWith(
        fontFamily: fontFamily,
        fontSize: 45,
      ),
      displaySmall: textTheme.displaySmall!.copyWith(
        fontFamily: fontFamily,
        fontSize: 36,
      ),
      headlineLarge: textTheme.headlineLarge!.copyWith(
        fontFamily: fontFamily,
        fontSize: 32,
      ),
      headlineMedium: textTheme.headlineMedium!.copyWith(
        fontFamily: fontFamily,
        fontSize: 28,
      ),
      headlineSmall: textTheme.headlineSmall!.copyWith(
        fontFamily: fontFamily,
        fontSize: 24,
      ),
      titleLarge: textTheme.titleLarge!.copyWith(
        fontFamily: fontFamily,
        fontSize: 22,
      ),
      titleMedium: textTheme.titleMedium!.copyWith(
        fontFamily: fontFamily,
        fontSize: 16,
      ),
      titleSmall: textTheme.titleSmall!.copyWith(
        fontFamily: fontFamily,
        fontSize: 14,
      ),
      bodyLarge: textTheme.bodyLarge!.copyWith(
        fontFamily: fontFamily,
        fontSize: 16,
      ),
      bodyMedium: textTheme.bodyMedium!.copyWith(
        fontFamily: fontFamily,
        fontSize: 14,
      ),
      bodySmall: textTheme.bodySmall!.copyWith(
        fontFamily: fontFamily,
        fontSize: 12,
      ),
      labelLarge: textTheme.labelLarge!.copyWith(
        fontFamily: fontFamily,
        fontSize: 14,
      ),
      labelMedium: textTheme.labelMedium!.copyWith(
        fontFamily: fontFamily,
        fontSize: 12,
      ),
      labelSmall: textTheme.labelSmall!.copyWith(
        fontFamily: fontFamily,
        fontSize: 11,
      ),
    );
    return textTheme;
  }

  @override
  ThemeData get light {
    final AppTheme appTheme = _appTheme;
    final textTheme = getTextTheme(appTheme, brightness: Brightness.light);
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: appTheme.primary,
      fontFamily: appTheme.fontFamily,
      textTheme: textTheme,
      searchBarTheme: SearchBarThemeData(
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(const Color(0xFFfaf9fd)),
        side: WidgetStateProperty.all(BorderSide(color: Colors.grey.shade300)),
      ),
      shadowColor: Colors.grey.shade300,
      scaffoldBackgroundColor: const Color(0Xfff2f2f2),
      canvasColor: const Color(0Xfffaf9fd),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0Xfffaf9fd),
        shape: RoundedRectangleBorder(
          borderRadius: appTheme.cardBorderRadius,
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      cardColor: const Color(0Xfffaf9fd),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: appTheme.cardBorderRadius,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade300,
        foregroundColor: appTheme.textColor,
        surfaceTintColor: Colors.white,
        elevation: 20,
      ),
      dividerColor: Colors.grey.shade300,
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: Colors.grey.shade300,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appTheme.textColor,
        linearTrackColor: Colors.grey.withOpacity(0.3),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: appTheme.primary,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appTheme.primary.shade100,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: textTheme.bodyLarge!.copyWith(
          color: appTheme.primary,
        ),
        side: BorderSide(
          color: appTheme.primary.shade100,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: appTheme.primary,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: NoPageTransitionsBuilder(),
        },
      ),
      extensions: [
        appTheme,
      ],
    );
  }

  @override
  ThemeData get dark {
    final AppTheme appTheme = _appTheme.copyWith(
      textColor: MaterialColorGenerator.from(Colors.white, reverse: true, swatch: {
        50: const Color(0xFF111111),
        100: const Color(0xFF333333),
        200: const Color(0xFF666666),
        300: const Color(0xFF999999),
        400: const Color(0xFFCCCCCC),
        500: const Color(0xFFFFFFFF),
      }),
      // primary: MaterialColorGenerator.from(const Color(0xFF6da0e0), reverse: true),
      secondary: MaterialColorGenerator.from(const Color(0xFF3d2c84), reverse: true),
      // accent: MaterialColorGenerator.from(const Color(0xFFcb0065), reverse: true),
      // success: MaterialColorGenerator.from(const Color(0xFF5db891), reverse: true),
      // danger: MaterialColorGenerator.from(const Color(0xFFbb0b0b), reverse: false),
      // warning: MaterialColorGenerator.from(const Color(0xFFf2b707), reverse: true),
      // info: MaterialColorGenerator.from(const Color(0xFF0b7abb), reverse: true),
      sidebar: MaterialColorGenerator.from(const Color(0xFF1a1a1a)),
    );
    final textTheme = getTextTheme(appTheme, brightness: Brightness.dark);
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorSchemeSeed: appTheme.primary,
      fontFamily: appTheme.fontFamily,
      textTheme: textTheme,
      searchBarTheme: SearchBarThemeData(
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(const Color(0xFF1a1a1a)),
        side: WidgetStateProperty.all(const BorderSide(
          color: Color(0xFF666666),
          width: 1,
        )),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      shadowColor: Colors.grey.shade700,
      scaffoldBackgroundColor: const Color(0xFF212121),
      canvasColor: const Color(0xFF212121),
      cardTheme: CardThemeData(
        elevation: 1,
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: appTheme.cardBorderRadius,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white.withOpacity(0.5)),
        trackColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: appTheme.danger,
      ),
      cardColor: Colors.black,
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: appTheme.cardBorderRadius,
        ),
        surfaceTintColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: appTheme.textColor,
        surfaceTintColor: Colors.white,
      ),
      dividerColor: Colors.grey.shade700,
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: Colors.grey.shade700,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appTheme.textColor,
        linearTrackColor: Colors.grey.withOpacity(0.3),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: appTheme.primary,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: appTheme.primary.shade100,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: textTheme.bodyLarge!.copyWith(
          color: appTheme.primary,
        ),
        side: BorderSide(
          color: appTheme.primary.shade100,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1a1a1a),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color(0xFF666666),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color(0xFF666666),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Color(0xFF666666),
            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: appTheme.primary,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: NoPageTransitionsBuilder(),
        },
      ),
      extensions: [
        appTheme,
      ],
    );
  }
}
