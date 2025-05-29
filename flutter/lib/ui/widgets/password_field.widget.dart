import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:zxcvbn/zxcvbn.dart';

class PasswordFormField extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? enabled;
  final TextAlign? textAlign;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final bool disableAutofill;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const PasswordFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.enabled,
    this.textAlign,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.suffixIcon,
    this.disableAutofill = false,
    this.labelText,
    this.floatingLabelBehavior,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: widget.disableAutofill ? null : [AutofillHints.password],
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_showPassword,
      controller: widget.controller,
      enabled: widget.enabled,
      textAlign: widget.textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        labelText: widget.labelText,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.suffixIcon ?? const SizedBox(),
            IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ],
        ),
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}

class PasswordStrengthFormField extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? enabled;
  final TextAlign? textAlign;
  final void Function(String, double?)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final zxcvbn = Zxcvbn();
  final colors = [
    Colors.red,
    Colors.red,
    Colors.grey,
    Colors.green,
    Colors.green,
  ];
  final List<String> userInputs;
  final int minStrength;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;

  PasswordStrengthFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.enabled,
    this.textAlign,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.userInputs = const [],
    this.minStrength = 2,
    this.labelText,
    this.floatingLabelBehavior,
  });

  @override
  State<PasswordStrengthFormField> createState() => _PasswordStrengthFormFieldState();
}

class _PasswordStrengthFormFieldState extends State<PasswordStrengthFormField> {
  int? _passwordStrength;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      final value = widget.controller!.text;
      if (value.isNotEmpty) {
        final score = widget.zxcvbn.evaluate(value, userInputs: widget.userInputs).score;
        setState(() {
          _passwordStrength = score?.round();
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant PasswordStrengthFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null) {
      final value = widget.controller!.text;
      if (value.isNotEmpty) {
        final score = widget.zxcvbn.evaluate(value, userInputs: widget.userInputs).score;
        setState(() {
          _passwordStrength = score?.round();
        });
      }
    }
  }

  String get strengthLabel {
    if (_passwordStrength == null) {
      return "";
    }

    if (_passwordStrength == 0) {
      return S.of(context).passwordStrength_0;
    } else if (_passwordStrength == 1) {
      return S.of(context).passwordStrength_1;
    } else if (_passwordStrength == 2) {
      return S.of(context).passwordStrength_2;
    } else if (_passwordStrength == 3) {
      return S.of(context).passwordStrength_3;
    } else if (_passwordStrength == 4) {
      return S.of(context).passwordStrength_4;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return PasswordFormField(
      disableAutofill: true,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      controller: widget.controller,
      enabled: widget.enabled,
      textAlign: widget.textAlign ?? TextAlign.start,
      labelText: widget.labelText,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      suffixIcon: Builder(builder: (context) {
        final strength = _passwordStrength;
        if (strength == null) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            strengthLabel,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: widget.colors[strength],
            ),
          ),
        );
      }),
      onChanged: (value) {
        double? score;
        if (value.isEmpty) {
          setState(() {
            _passwordStrength = null;
          });
        } else {
          score = widget.zxcvbn.evaluate(value, userInputs: widget.userInputs).score;
          setState(() {
            _passwordStrength = score?.round();
          });
        }
        if (widget.onChanged != null) {
          widget.onChanged!(value, score);
        }
      },
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return S.of(context).error_required_field;
        }
        if (_passwordStrength != null && _passwordStrength! < widget.minStrength) {
          return S.of(context).error_password_strength;
        }
        return null;
      },
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
