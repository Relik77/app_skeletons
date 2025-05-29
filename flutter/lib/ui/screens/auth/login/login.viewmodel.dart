import 'package:flutter/material.dart';
import 'package:sample_project/shared/services/auth.service.dart';
import 'package:sample_project/ui/navigation/application.state.dart';
import 'package:sample_project/ui/screens/auth/login/login.screen.dart';
import 'package:sample_project/ui/widgets/checkbox_form_field.widget.dart';

class LoginViewModel extends ChangeNotifier implements ILoginViewModel {
  final TextEditingController _mailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final CheckboxEditingController _rememberMeController = CheckboxEditingController(initialValue: false);

  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  LoginError? _error;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  TextEditingController get mailTextController => _mailTextController;

  @override
  TextEditingController get passwordTextController => _passwordTextController;

  @override
  CheckboxEditingController get rememberMeController => _rememberMeController;

  @override
  bool get submitting => _submitting;

  @override
  LoginError? get error => _error;

  @override
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      final email = mailTextController.text.toLowerCase();
      final password = passwordTextController.text;
      final remember = rememberMeController.checked;

      _submitting = true;
      _error = null;
      notifyListeners();

      AuthService.instance
          .login(
        email: email,
        password: password,
        remember: remember,
      )
          .then((user) {
        _submitting = false;
        ApplicationState.instance?.login(user);
        notifyListeners();
      }).catchError((error) {
        if (error is LoginError) {
          _error = error;
        } else {
          _error = LoginError.unknown;
        }
        _submitting = false;
        notifyListeners();
      });
    }
  }
}
