import 'package:flutter/material.dart';
import 'package:sample_project/themes/app_theme.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Color? borderColor;

  const BadgeWidget({
    super.key,
    required this.text,
    this.width,
    this.borderRadius,
    this.color,
    this.borderColor,
  });

  factory BadgeWidget.count({
    required int count,
    int max = 99,
    double? width,
  }) {
    return BadgeWidget(
      text: count > max ? "$max+" : count.toString(),
      width: width,
    );
  }

  factory BadgeWidget.dot({
    double? width,
    Color? color,
    Color? borderColor,
  }) {
    return BadgeWidget(
      text: "",
      width: width,
      borderRadius: BorderRadius.circular(100),
      color: color,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 4,
        right: 4,
        top: 2,
      ),
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        color: color ?? AppTheme.of(context).danger,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
              )
            : null,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
