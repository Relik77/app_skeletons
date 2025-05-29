import 'package:flutter/material.dart';
import 'package:sample_project/themes/app_theme.dart';

class MenuItemWidget extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Widget? trailingOnHover;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;
  final Function()? onTap;

  const MenuItemWidget({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.trailingOnHover,
    this.dense,
    this.contentPadding,
    this.selected = false,
    this.onTap,
  });

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    Gradient? gradient;
    if (_hover) {
      gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppTheme.of(context).accent,
          Colors.transparent,
        ],
      );
    }
    if (widget.selected) {
      gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppTheme.of(context).accent,
          Colors.transparent,
        ],
      );
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => {},
        onHover: (hover) {
          setState(() {
            _hover = hover;
          });
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          child: ListTile(
            onTap: widget.onTap,
            contentPadding: widget.contentPadding,
            dense: widget.dense,
            leading: widget.leading,
            title: widget.title,
            trailing: _hover ? widget.trailingOnHover : widget.trailing,
          ),
        ),
      ),
    );
  }
}
