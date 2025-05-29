import 'package:flutter/material.dart';
import 'package:sample_project/ui/screens/dashboard/dashboard.screen.dart';

class DashboardViewModel extends ChangeNotifier implements IDashboardViewModel {
  bool _mounted = false;

  DashboardViewModel() {
    _mounted = true;
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }
}
