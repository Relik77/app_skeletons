// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account_title": MessageLookupByLibrary.simpleMessage("Account"),
        "app_title": MessageLookupByLibrary.simpleMessage("My Flutter Project"),
        "error_account_not_found":
            MessageLookupByLibrary.simpleMessage("Email or password incorrect"),
        "error_email_already_exists":
            MessageLookupByLibrary.simpleMessage("Email already exists"),
        "error_email_format":
            MessageLookupByLibrary.simpleMessage("Invalid email format"),
        "error_password_match":
            MessageLookupByLibrary.simpleMessage("Passwords don\'t match"),
        "error_password_strength": MessageLookupByLibrary.simpleMessage(
            "Please choose a stronger password"),
        "error_required_field":
            MessageLookupByLibrary.simpleMessage("This field is required"),
        "error_unknown":
            MessageLookupByLibrary.simpleMessage("An error occurred"),
        "error_wrong_password":
            MessageLookupByLibrary.simpleMessage("Wrong password"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "loginScreen_emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "loginScreen_forgotPasswordButton":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "loginScreen_loginButton":
            MessageLookupByLibrary.simpleMessage("Login"),
        "loginScreen_passwordLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "loginScreen_registerButton":
            MessageLookupByLibrary.simpleMessage("Register"),
        "loginScreen_rememberMeLabel":
            MessageLookupByLibrary.simpleMessage("Remember me"),
        "myDashboard_title":
            MessageLookupByLibrary.simpleMessage("My Dashboard"),
        "notFoundScreen_title":
            MessageLookupByLibrary.simpleMessage("Page not found"),
        "passwordStrength_0": MessageLookupByLibrary.simpleMessage("Weak"),
        "passwordStrength_1": MessageLookupByLibrary.simpleMessage("Weak"),
        "passwordStrength_2":
            MessageLookupByLibrary.simpleMessage("Acceptable"),
        "passwordStrength_3": MessageLookupByLibrary.simpleMessage("Strong"),
        "passwordStrength_4": MessageLookupByLibrary.simpleMessage("Strong")
      };
}
