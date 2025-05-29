import 'package:flutter/material.dart';
import 'package:sample_project/ui/layout/custom_screen.widget.dart';

abstract class IDashboardViewModel extends ChangeNotifier {}

class DashboardScreen extends StatefulWidget {
  final IDashboardViewModel _viewModel;

  const DashboardScreen(
      this._viewModel, {
        super.key,
      });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  IDashboardViewModel get viewModel => widget._viewModel;

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, child) {
            return Text('Dashboard');
          }),
    );
  }
}
