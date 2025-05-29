import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/themes/app_theme.dart';

class CheckboxEditingValue {
  final bool checked;

  const CheckboxEditingValue({
    this.checked = false,
  });

  factory CheckboxEditingValue.fromJSON(Map<String, dynamic> encoded) {
    return CheckboxEditingValue(
      checked: encoded['checked'] as bool,
    );
  }

  CheckboxEditingValue copyWith({
    bool? checked,
  }) {
    return CheckboxEditingValue(
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'checked': checked,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckboxEditingValue && other.checked == checked;
  }

  @override
  int get hashCode => checked.hashCode;
}

class CheckboxEditingController extends ValueNotifier<CheckboxEditingValue> {
  bool get checked => value.checked;
  set checked(bool newValue) {
    value = value.copyWith(checked: newValue);
  }

  CheckboxEditingController({
    bool initialValue = false,
  }) : super(CheckboxEditingValue(checked: initialValue));

  CheckboxEditingController.fromValue(CheckboxEditingValue? value) : super(value ?? const CheckboxEditingValue());

  void clear() {
    value = const CheckboxEditingValue();
  }
}

class RestorableCheckboxEditingController extends RestorableChangeNotifier<CheckboxEditingController> {
  factory RestorableCheckboxEditingController({bool checked = false}) => RestorableCheckboxEditingController.fromValue(
    CheckboxEditingValue(checked: checked),
  );

  RestorableCheckboxEditingController.fromValue(CheckboxEditingValue value) : _initialValue = value;

  final CheckboxEditingValue _initialValue;

  @override
  CheckboxEditingController createDefaultValue() {
    return CheckboxEditingController.fromValue(_initialValue);
  }

  @override
  CheckboxEditingController fromPrimitives(Object? data) {
    return CheckboxEditingController(initialValue: data as bool? ?? false);
  }

  @override
  Object toPrimitives() {
    return value.value;
  }
}

class CheckboxFormField extends FormField<bool> {
  final CheckboxEditingController? controller;
  final bool required;
  final ValueChanged<bool>? onChanged;
  final InputDecoration? decoration;
  final EdgeInsetsGeometry? contentPadding;

  CheckboxFormField({
    super.key,
    bool? initialValue,
    bool? enabled,
    AutovalidateMode? autovalidateMode,
    this.controller,
    this.required = false,
    this.onChanged,
    super.restorationId,
    this.decoration,
    this.contentPadding,
    FormFieldValidator<bool>? validator,
    required String label,
  }) : super(
    initialValue: controller != null ? controller.checked : initialValue,
    enabled: enabled ?? decoration?.enabled ?? true,
    autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
    validator: validator ??
            (bool? value) {
          if (required && value == null) {
            return S.current.error_required_field;
          }
          return null;
        },
    builder: (FormFieldState<bool> field) {
      void onChangedHandler(bool value) {
        field.didChange(value);
        if (onChanged != null) {
          onChanged(value);
        }
      }

      return UnmanagedRestorationScope(
          bucket: field.bucket,
          child: Builder(builder: (context) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: contentPadding,
              title: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: field.errorText != null
                  ? Text(
                field.errorText!,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppTheme.of(context).danger,
                ),
              )
                  : null,
              activeColor: AppTheme.of(context).primary,
              side: BorderSide(
                color: field.hasError ? AppTheme.of(context).danger : AppTheme.of(context).textColor.shade300,
                width: 2,
              ),
              value: field.value,
              onChanged: (isChecked) {
                onChangedHandler(isChecked ?? false);
              },
            );
          }));
    },
  );

  @override
  FormFieldState<bool> createState() => _CheckboxFormFieldState();
}

class _CheckboxFormFieldState extends FormFieldState<bool> {
  RestorableCheckboxEditingController? _controller;

  CheckboxFormField get _checkboxFormField => super.widget as CheckboxFormField;
  CheckboxEditingController get _effectiveController => _checkboxFormField.controller ?? _controller!.value;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    setValue(_effectiveController.checked);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([CheckboxEditingValue? value]) {
    assert(_controller == null);
    _controller =
    value == null ? RestorableCheckboxEditingController() : RestorableCheckboxEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_checkboxFormField.controller == null) {
      _createLocalController(
          widget.initialValue != null ? CheckboxEditingValue(checked: widget.initialValue ?? false) : null);
    } else {
      _checkboxFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(CheckboxFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_checkboxFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _checkboxFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _checkboxFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_checkboxFormField.controller != null) {
        setValue(_checkboxFormField.controller!.checked);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _checkboxFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(bool? value) {
    super.didChange(value);

    if (_effectiveController.checked != value) {
      _effectiveController.checked = value ?? false;
    }
  }

  @override
  void reset() {
    _effectiveController.checked = widget.initialValue ?? false;
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController.checked != value) {
      didChange(_effectiveController.checked);
    }
  }
}
