
import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/themes/app_theme.dart';
import 'package:sample_project/ui/layout/custom_screen.widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      center: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.of(context).primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            S.of(context).loading,
            style: TextStyle(
              color: AppTheme.of(context).primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}