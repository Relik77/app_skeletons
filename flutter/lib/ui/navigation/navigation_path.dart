
import 'package:sample_project/ui/navigation/navigation.state.dart';

class NavigationPage {
  final String name;
  final Map<String, dynamic> parameters;

  NavigationPage({
    required this.name,
    this.parameters = const {},
  });

  bool hasParameter(String name) => parameters.containsKey(name);
  dynamic getParameter(String name) => parameters[name];

  @override
  String toString() {
    return "NavigationPage($name, $parameters)";
  }
}

class NavigationPath {
  NavigationPage? currentPage;
  String? currentTab;
  FormValues? formValues;

  NavigationPath({
    this.currentPage,
    this.currentTab,
    this.formValues,
  });
}
