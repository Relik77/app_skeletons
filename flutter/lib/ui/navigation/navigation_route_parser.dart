
import 'package:flutter/cupertino.dart';
import 'package:sample_project/shared/services/core/storage.service.dart';
import 'package:sample_project/ui/navigation/navigation.state.dart';
import 'package:sample_project/ui/navigation/navigation_path.dart';

class NavigationRouteParser extends RouteInformationParser<NavigationPath> {
  @override
  RouteInformation? restoreRouteInformation(NavigationPath configuration) {
    List<String> location = [""];
    Map<String, dynamic>? queryParameters = {};

    final currentPage = configuration.currentPage;
    if (currentPage != null) {
      if (currentPage.name != "home") {
        location.add(currentPage.name);
        if (currentPage.parameters.isNotEmpty) {
          for (final parametre in currentPage.parameters.keys) {
            final value = currentPage.parameters[parametre];
            if (value != null) {
              location.add(value.toString());
            }
          }
        }
      }
    }
    if (configuration.currentTab != null) {
      queryParameters["tab"] = configuration.currentTab;
    }
    if (configuration.formValues != null) {
      StorageService.setJSON("formValues", configuration.formValues!.toJson());
    } else {
      StorageService.delete("formValues");
    }

    return RouteInformation(
      uri: Uri(
        pathSegments: location,
        queryParameters: queryParameters,
      ),
    );
  }

  @override
  Future<NavigationPath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    final navigationPath = NavigationPath();
    bool loop = true;

    final pathSegments = [...uri.pathSegments];
    while (loop) {
      if (pathSegments.isEmpty || pathSegments.length == 1) {
        break;
      }

      final segment = pathSegments.first;
      switch (segment) {
        default:
          loop = false;
          break;
      }
    }
    if (pathSegments.isNotEmpty) {
      final currentPage = pathSegments.removeAt(0);
      final parametres = NavigationState.pages[currentPage];
      navigationPath.currentPage = NavigationPage(
        name: currentPage,
        parameters: (parametres != null)
            ? {for (final parametre in parametres) parametre: pathSegments.isNotEmpty ? pathSegments.removeAt(0) : null}
            : {},
      );
    }

    final queryParameters = uri.queryParameters;
    if (queryParameters.containsKey("tab")) {
      navigationPath.currentTab = queryParameters["tab"];
    }
    final formValues = await StorageService.getJSON("formValues");
    if (formValues != null) {
      navigationPath.formValues = FormValues(
        formName: formValues["formName"],
        data: formValues["data"],
      );
    }

    return navigationPath;
  }
}