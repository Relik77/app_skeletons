import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/shared/resource.dart';
import 'package:sample_project/shared/services/log.service.dart';
import 'package:sample_project/themes/themes.dart';
import 'package:sample_project/ui/navigation/navigation_delegate.dart';
import 'package:sample_project/ui/navigation/navigation_route_parser.dart';

printError(String text) {
  print("\x1B[31m$text\x1B[0m");
}

printWarning(String text) {
  print("\x1B[33m$text\x1B[0m");
}

printLevel(String text, {Level? level}) {
  switch (level?.name) {
    case 'SEVERE':
      printError(text);
      break;
    case 'WARNING':
      printWarning(text);
      break;
    default:
      print(text);
  }
}

class Log {
  String message = "";
  LogType type = LogType.error;
  LogSource source = LogSource.app;

  add(String message, {Level? level}) {
    printLevel(message, level: level);
    this.message += "$message\n";
  }
}

void main() {
  Intl.defaultLocale = 'fr';
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.CONFIG;
  Logger.root.onRecord.listen((record) {
    final log = Log();
    if (record.level > Level.WARNING) {
      log.type = LogType.error;
    } else if (record.level == Level.WARNING) {
      log.type = LogType.warning;
    } else {
      log.type = LogType.info;
    }

    log.add('[${record.loggerName}] ${record.level.name}: ${record.message}', level: record.level);
    if (record.error != null) {
      log.add("${record.error}", level: record.level);
    }
    final error = record.error;
    if (error is Error) {
      final lines = error.stackTrace.toString().split('\n').where((line) {
        return line.contains('packages/smanck');
      });
      if (lines.isEmpty) {
        log.add(error.stackTrace.toString());
      } else {
        log.add(lines.take(3).join('\n'));
      }
    // } else if (error is ApiError) {
    //   log.source = LogSource.api;
    //   log.add(error.stackTrace.toString());
    } else if (record.stackTrace != null) {
      final lines = record.stackTrace.toString().split('\n').where((line) {
        return line.contains('packages/smanck');
      });
      if (lines.isEmpty) {
        log.add(record.stackTrace.toString());
      } else {
        log.add(lines.take(3).join('\n'));
      }
    }
    // printLevel("------------------");

    final logService = LogService();
    logService.sendLog(
      message: log.message,
      type: log.type,
      source: log.source,
    );
  });

  if (!kDebugMode) {
    print("v${Resource.buildVersion} - ${Resource.env} - ${Resource.buildDate}");
  }


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NavigationDelegate _navigationDelegate;
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _navigationDelegate = NavigationDelegate(
    );
  }

  @override
  void dispose() {
    _themeManager.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final momentLocal = MomentLocalizations.byLocale(Intl.getCurrentLocale());
    if (momentLocal != null) {
      Moment.setGlobalLocalization(momentLocal);
    }
    return Portal(
      child: AnimatedBuilder(
          animation: _themeManager,
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (context) => S.of(context).app_title,
              theme: _themeManager.currentTheme.light,
              darkTheme: _themeManager.currentTheme.dark,
              themeMode: _themeManager.themeMode,
              routeInformationParser: NavigationRouteParser(),
              routerDelegate: _navigationDelegate,
              builder: FlutterSmartDialog.init(),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
            );
          }),
    );
  }
}
