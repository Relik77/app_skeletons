import 'package:flutter/material.dart';
import 'package:sample_project/shared/utils.dart';

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButtonStyle extends ButtonStyle {
  CustomButtonStyle({
    Color? backgroundColor,
    double borderRadius = 16,
    EdgeInsets padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 32,
    ),
    hasPrefixIcon = false,
    hasSuffixIcon = false,
  }) : super(
    backgroundColor: backgroundColor != null ? WidgetStateProperty.all<Color>(backgroundColor) : null,
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(padding.copyWith(
      left: hasPrefixIcon ? 16 : padding.left,
      right: hasSuffixIcon ? 16 : padding.right,
    )),
  );
}

class CustomButtonLabel extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool textCapitalization;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;

  const CustomButtonLabel({
    super.key,
    required this.label,
    this.color = const Color(0xFF333333),
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = true,
    this.fontWeight,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ?? Theme.of(context).textTheme.bodyMedium!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(
            prefixIcon,
            color: color,
            size: (textStyle.fontSize ?? 14) * 1.71,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          textCapitalization ? label.toUpperCase() : label,
          style: textStyle.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
        ),
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(
            suffixIcon,
            color: color,
            size: (textStyle.fontSize ?? 14) * 1.71,
          )
        ],
      ],
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;
  final ButtonSize size;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.prefixIcon,
    this.suffixIcon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? Theme.of(context).primaryColor;
    EdgeInsets? padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 32,
    );
    TextStyle? textStyle;
    if (size == ButtonSize.small) {
      padding = const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      );
      textStyle = Theme.of(context).textTheme.bodySmall;
    } else if (size == ButtonSize.large) {
      padding = const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 48,
      );
      textStyle = Theme.of(context).textTheme.bodyLarge;
    }

    return ElevatedButton(
      style: CustomButtonStyle(
        backgroundColor: onPressed == null ? color.withOpacity(0.5) : color,
        hasPrefixIcon: prefixIcon != null,
        hasSuffixIcon: suffixIcon != null,
        padding: padding,
      ),
      onPressed: onPressed,
      child: CustomButtonLabel(
        label: label,
        color: getContrastColor(color),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        textStyle: textStyle,
      ),
    );
  }
}
