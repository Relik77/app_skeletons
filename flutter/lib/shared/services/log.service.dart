import 'package:flutter/foundation.dart';

enum LogType {
  info,
  warning,
  error,
}

String logTypeToString(LogType type) {
  switch (type) {
    case LogType.error:
      return 'error';
    case LogType.warning:
      return 'warning';
    case LogType.info:
      return 'info';
    default:
      return 'info';
  }
}

enum LogSource {
  app,
  api,
}

String logSourceToString(LogSource source) {
  switch (source) {
    case LogSource.app:
      return 'app';
    case LogSource.api:
      return 'api';
    default:
      return 'app';
  }
}

class LogService {
  Future<void> sendLog({
    required String message,
    required LogType type,
    required LogSource source,
  }) async {
    if (type.index < LogType.warning.index || kDebugMode) {
      return;
    }
    try {
      // TODO: send log to server
    } catch (e) {
      // ignore: avoid_print
      print('Failed to send log: $e');
    }
  }
}
