import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sample_project/shared/models/user.model.dart';
import 'package:sample_project/shared/services/auth.service.dart';
import 'package:sample_project/shared/services/core/storage.service.dart';
import 'package:sample_project/ui/navigation/application.state.dart';
import 'package:sample_project/ui/navigation/navigation.state.dart';
import 'package:sample_project/ui/navigation/navigation_path.dart';
import 'package:sample_project/ui/screens/auth/login/login.screen.dart';
import 'package:sample_project/ui/screens/auth/login/login.viewmodel.dart';
import 'package:sample_project/ui/screens/dashboard/dashboard.screen.dart';
import 'package:sample_project/ui/screens/dashboard/dashboard.viewmodel.dart';
import 'package:sample_project/ui/screens/loading/loading.screen.dart';
import 'package:sample_project/ui/screens/not_found/not_found.screen.dart';

final _log = Logger("NavigationDelegate");

// https://stackoverflow.com/questions/58956814/how-to-execute-a-function-after-a-period-of-inactivity-in-flutter/59904022#59904022
class _KeepAliveObserver extends WidgetsBindingObserver {
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ApplicationState.userState = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        ApplicationState.userState = false;
        break;
      default:
        break;
    }
  }
}

class _ApplicationState extends ApplicationState {
  AuthUser? _currentUser;

  @override
  AuthUser? get currentUser => _currentUser;

  _ApplicationState() : super() {
    ApplicationState.instance = this;
  }

  void setCurrentUser(AuthUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  @override
  void login(AuthUser user) {
    setCurrentUser(user);
    NavigationState.instance?.home();
  }

  @override
  void logout() {
    setCurrentUser(null);
    NavigationState.instance?.home();
    AuthService.instance.logout();
  }


  void _saveState() {
    StorageService.setJSON("lastState", {
      // TODO save app state vars
    });
  }

  Future<void> _loadState() {
    // TODO load project, branch and task from last state (Mostly on mobile app)
    return StorageService.getJSON("lastState").then((state) {
      if (state != null) {
        // TODO load app state from vars
      }
    });
  }
}

class _NavigationState extends NavigationState {
  final List<int> _history = [NavigationState.homePage];
  int _stack = NavigationState.homePage;
  String? _currentTab;
  FormValues? _formValues;

  @override
  String? get currentTab => _currentTab;

  @override
  set currentTab(String? value) {
    _currentTab = value;
    notifyListeners();
  }

  @override
  FormValues? get formValues => _formValues;

  @override
  int get stack => _stack;

  @override
  int get lastPage => _history.last;

  @override
  int get historyLength => _history.length;

  List<int> get pages {
    final List<int> pages = [];
    int stack = _stack;
    for (int i = _history.length - 1; i >= 0; i--) {
      final page = _history[i];
      if (stack & page == 0) {
        continue;
      }
      pages.insert(0, page);
      stack = stack ^ page;
    }

    return pages;
  }

  _NavigationState() : super() {
    NavigationState.instance = this;
  }

  void _push(int state) {
    if (_history.last == state) {
      return;
    }
    _history.add(state);
    _stack = _stack | state;
  }

  void _pop() {
    final last = _history.removeLast();
    _stack = (_stack ^ last) | _history.last;
  }

  void _set(int state) {
    _history.clear();
    _history.add(state);
    _stack = state;
  }

  @override
  void register() {
    _set(NavigationState.registerPage);
    notifyListeners();
  }

  @override
  void login() {
    _set(NavigationState.loginPage);
    notifyListeners();
  }

  @override
  void lostPassword() {
    _set(NavigationState.lostPasswordPage);
    notifyListeners();
  }

  @override
  void account() {
    _push(NavigationState.accountPage);
    notifyListeners();
  }

  @override
  void back() {
    if (_history.length > 1) {
      _pop();
      notifyListeners();
    }
  }

  @override
  void home() {
    _set(NavigationState.homePage);
    notifyListeners();
  }
}

class NavigationDelegate extends RouterDelegate<NavigationPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationPath> {
  final _ApplicationState _applicationState = _ApplicationState();
  final _NavigationState _navigationState = _NavigationState();
  final Map<int, dynamic> _viewModels = {};
  final Map<int, dynamic> _viewModelsParameters = {};

  bool _isLoading = false;
  bool _firstLoad = true;

  NavigationDelegate()  : super() {
    WidgetsBinding.instance.addObserver(_KeepAliveObserver());
    _navigationState.addListener(() {
      notifyListeners();
    });
    _applicationState.addListener(() {
      notifyListeners();
    });
  }

  cleanViewModels() {
    final keys = _viewModels.keys.toList();
    for (final key in keys) {
      if (!_navigationState.pages.contains(key)) {
        final viewModel = _viewModels.remove(key);
        _viewModelsParameters.remove(key);
        if (viewModel is ChangeNotifier) {
          viewModel.dispose();
        }
      }
    }
  }

  T restoreViewModel<T>(
      int key,
      ValueGetter<T> defaultViewModelGetter, [
        bool force = false,
        List<dynamic> parameters = const [],
      ]) {
    bool parametersChanged = false;
    if (_viewModelsParameters.containsKey(key)) {
      final oldParameters = _viewModelsParameters[key];
      if (oldParameters.length != parameters.length) {
        parametersChanged = true;
      } else {
        for (int i = 0; i <= oldParameters.length - 1; i++) {
          if (oldParameters[i] != parameters[i]) {
            parametersChanged = true;
            break;
          }
        }
      }
    } else {
      parametersChanged = true;
    }
    _viewModelsParameters[key] = parameters;
    if (force || parametersChanged) {
      final viewModel = _viewModels.remove(key);
      if (viewModel is ChangeNotifier) {
        viewModel.dispose();
      }
    }
    if (_viewModels.containsKey(key)) {
      final viewModel = _viewModels[key];
      if (viewModel is T) {
        return viewModel;
      }
    }
    T defaultViewModel = defaultViewModelGetter();
    _viewModels[key] = defaultViewModel;
    return defaultViewModel;
  }

  Page<MaterialPage> _buildHomePage({
    required BuildContext context,
    required int page,
  }) {
    return MaterialPage(
      child: DashboardScreen(
        restoreViewModel(
          page,
              () => DashboardViewModel(),
          true,
        ),
      ),
    );
  }

  Page<MaterialPage>? buildPage({
    required BuildContext context,
    required int page,
  }) {
    switch (page) {
      case NavigationState.homePage:
        return _buildHomePage(
          context: context,
          page: page,
        );
    }
    return null;
  }

  List<Page<MaterialPage>> buildPages({
    required BuildContext context,
  }) {
    final List<Page<MaterialPage>> pages = [];
    final stack = _navigationState.pages;

    if (_isLoading) {
      pages.add(
        const MaterialPage(
          child: LoadingScreen(),
        ),
      );
      return pages;
    }

    if (!_applicationState.isLogged) {
      pages.add(
        MaterialPage(
          child: LoginScreen(
            LoginViewModel(),
          ),
        ),
      );
      return pages;
    }

    cleanViewModels();
    for (int i = 0; i <= stack.length - 1; i++) {
      final page = buildPage(
        context: context,
        page: stack[i],
      );
      if (page != null) {
        pages.add(page);
      }
    }
    if (pages.isEmpty) {
      pages.add(
        const MaterialPage(
          child: NotFoundScreen(),
        ),
      );
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = buildPages(
      context: context,
    );

    return Navigator(
      pages: pages,
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (route.didPop(result) == false) {
          return false;
        }
        return onBack(result);
      },
    );
  }

  bool onBack(dynamic result) {
    _navigationState._pop();
    notifyListeners();
    return true;
  }

  @override
  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  @override
  NavigationPath? get currentConfiguration => NavigationPath(
    currentPage: _navigationState.currentPage,
    currentTab: _navigationState._currentTab,
    formValues: _navigationState.formValues,
  );

  @override
  Future<void> setNewRoutePath(NavigationPath configuration) {
    endLoading() {
      _isLoading = false;
      notifyListeners();
    }

    _navigationState._set(NavigationState.homePage);

    return Future(() async {
      _isLoading = true;
      bool loadLastState = _firstLoad;
      _firstLoad = false;
      notifyListeners();
      if (loadLastState) {
        await _applicationState._loadState();
      }

      if (configuration.currentTab != null) {
        _navigationState._currentTab = configuration.currentTab;
      }
      if (configuration.formValues != null) {
        _navigationState._formValues = configuration.formValues;
      }
      if (configuration.currentPage != null) {
        _goto(configuration.currentPage!);
      }

      endLoading();
    }).onError((error, stackTrace) {
      final log = Logger("Router");
      log.severe("Error while loading route", error, stackTrace);
    });
  }

  void _goto(NavigationPage page) {
    switch (page.name) {
      case "home":
        return;
    }
  }

  @override
  void dispose() {
    _applicationState.dispose();
    _navigationState.dispose();
    super.dispose();
  }
}