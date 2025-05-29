import 'package:flutter/material.dart';
import 'package:sample_project/generated/l10n.dart';
import 'package:sample_project/shared/services/auth.service.dart';
import 'package:sample_project/shared/utils.dart';
import 'package:sample_project/themes/app_theme.dart';
import 'package:sample_project/ui/layout/custom_screen.widget.dart';
import 'package:sample_project/ui/navigation/navigation.state.dart';
import 'package:sample_project/ui/widgets/buttons.dart';
import 'package:sample_project/ui/widgets/checkbox_form_field.widget.dart';
import 'package:sample_project/ui/widgets/label.widget.dart';
import 'package:sample_project/ui/widgets/password_field.widget.dart';

abstract class ILoginViewModel extends ChangeNotifier {
  GlobalKey<FormState> get formKey;
  TextEditingController get mailTextController;
  TextEditingController get passwordTextController;
  CheckboxEditingController get rememberMeController;
  bool get submitting;
  LoginError? get error;

  Future<void> login();
}

class LoginScreen extends StatefulWidget {
  final ILoginViewModel _viewModel;

  const LoginScreen(
      this._viewModel, {
        super.key,
      });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode pwdFocusNode = FocusNode();

  ILoginViewModel get viewModel => widget._viewModel;

  Widget _buildError({
    required BuildContext context,
  }) {
    final error = viewModel.error;
    if (error == null) return Container();
    String message = "";
    switch (error) {
      case LoginError.accountNotFound:
        message = S.of(context).error_account_not_found;
        break;
      case LoginError.wrongPassword:
        message = S.of(context).error_wrong_password;
        break;
      case LoginError.unknown:
        message = S.of(context).error_unknown;
        break;
      case LoginError.emailAlreadyExists:
        message = S.of(context).error_email_already_exists;
        break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      center: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset(
              //   Resource.appLogo,
              //   height: 45,
              // ),
              // const SizedBox(height: 16),
              AnimatedBuilder(
                  animation: viewModel,
                  builder: (context, child) {
                    return Form(
                      key: viewModel.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildError(context: context),
                          const SizedBox(height: 8),
                          Label(
                            label: S.of(context).loginScreen_emailLabel,
                            required: true,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            autofillHints: const [AutofillHints.email],
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            focusNode: emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            controller: viewModel.mailTextController,
                            enabled: !viewModel.submitting,
                            textAlign: TextAlign.center,
                            validator: (String? email) {
                              email = email ?? viewModel.mailTextController.text;
                              if (!isValidEmail(email)) {
                                return S.of(context).error_email_format;
                              }
                              return null;
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(pwdFocusNode);
                            },
                          ),
                          const SizedBox(height: 16),
                          Label(
                            label: S.of(context).loginScreen_passwordLabel,
                            required: true,
                          ),
                          const SizedBox(height: 4),
                          PasswordFormField(
                            textInputAction: TextInputAction.done,
                            focusNode: pwdFocusNode,
                            controller: viewModel.passwordTextController,
                            enabled: viewModel.submitting == false,
                            textAlign: TextAlign.center,
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return S.of(context).error_required_field;
                              }
                              return null;
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).unfocus();
                              viewModel.login();
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomElevatedButton(
                                onPressed: viewModel.login,
                                label: S.of(context).loginScreen_loginButton,
                                suffixIcon: Icons.chevron_right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CheckboxFormField(
                            controller: viewModel.rememberMeController,
                            label: S.of(context).loginScreen_rememberMeLabel,
                            validator: (value) {
                              if (value == null) {
                                return S.of(context).error_required_field;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              TextButton(
                                onPressed: NavigationState.instance?.lostPassword,
                                child: Text(
                                  S.of(context).loginScreen_forgotPasswordButton,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppTheme.of(context).primary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: NavigationState.instance?.register,
                                child: Text(
                                  S.of(context).loginScreen_registerButton,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
