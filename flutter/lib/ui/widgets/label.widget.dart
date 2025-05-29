import 'package:flutter/material.dart';
import 'package:sample_project/themes/app_theme.dart';

class Label extends StatelessWidget {
  final String label;
  final TextAlign? textAlign;
  final TextStyle? style;
  final Color? color;
  final bool required;

  const Label({
    super.key,
    required this.label,
    this.textAlign,
    this.style,
    this.color,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            style: textStyle.copyWith(
              color: color ?? AppTheme.of(context).textColor,
              // fontWeight: FontWeight.bold,
            ),
            textAlign: textAlign,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: textStyle.copyWith(
              color: const Color(0xFFE74C3C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
