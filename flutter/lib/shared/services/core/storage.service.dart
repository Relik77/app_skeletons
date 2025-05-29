import 'package:flutter/foundation.dart';
import 'package:sample_project/shared/services/core/storage/storage.interface.service.dart';
import 'package:sample_project/shared/services/core/storage/web-storage.service.dart';

// @JS("window.navigator.userAgent")
// external String get userAgent;
//
// @JS("window.chrome.storage")
// external dynamic get isChromeExtention;
//
// @JS("window.browser.storage")
// external dynamic get isFirefoxExtention;

// bool get isChrome => userAgent.contains("Chrome");
// bool get isFirefox => userAgent.contains("Firefox");
// bool get isChromeExt => isChrome && isChromeExtention != null;
// bool get isFirefoxExt => isFirefox && isFirefoxExtention != null;

abstract class _StorageService {
  static IStorageService get instance {
    if (kIsWeb) {
      // if (isChromeExt) return ChromeExtStorageService();
      // if (isFirefoxExt) return FirefoxExtStorageService();
      return WebStorageService();
    } else {
      return WebStorageService();
    }
  }
}

// ignore: non_constant_identifier_names
final StorageService = _StorageService.instance;