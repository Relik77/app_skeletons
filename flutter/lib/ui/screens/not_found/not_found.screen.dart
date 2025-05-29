import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/ui/layout/custom_screen.widget.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      center: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // SvgPicture.asset(
          //   Resource.illustrationEmpty,
          //   width: 200,
          // ),
          // const SizedBox(height: 20),
          Text(
            S.of(context).notFoundScreen_title,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
