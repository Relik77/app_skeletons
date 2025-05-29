import 'package:flutter/material.dart';
import 'package:sample_project/shared/models/user.model.dart';
import 'package:sample_project/shared/services/core/storage.service.dart';
import 'package:sample_project/ui/layout/side_menu/side_menu.widget.dart';
import 'package:sample_project/ui/navigation/application.state.dart';

class SideMenuViewModel extends ChangeNotifier implements ISideMenuViewModel {
  static const double defaultMaxWidth = 320;
  static const double defaultMinWidth = 60;

  double maxWidth;
  double minWidth;
  final ValueChanged<double>? onMenuToggle;

  bool _isCollapsed = false;

  @override
  User? get user => ApplicationState.instance?.currentUser;

  @override
  bool get isCollapsed => _isCollapsed;

  @override
  double get width => _isCollapsed ? minWidth : maxWidth;

  SideMenuViewModel({
    this.maxWidth = SideMenuViewModel.defaultMaxWidth,
    this.minWidth = SideMenuViewModel.defaultMinWidth,
    this.onMenuToggle,
  }) {
    StorageService.getBool('isCollapsed').then((value) {
      if (value != null) {
        _isCollapsed = value;
        onMenuToggle?.call(width);
        notifyListeners();
      }
    });
  }

  @override
  void setCollapsed(bool value) {
    _isCollapsed = value;
    StorageService.setBool('isCollapsed', _isCollapsed);
  }

  @override
  void toggleMenu() {
    setCollapsed(!_isCollapsed);
    onMenuToggle?.call(width);
    notifyListeners();
  }
}
