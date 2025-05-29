// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account_title": MessageLookupByLibrary.simpleMessage("Mon compte"),
        "app_title": MessageLookupByLibrary.simpleMessage("Mon Projet Flutter"),
        "error_account_not_found": MessageLookupByLibrary.simpleMessage(
            "Email ou mot de passe incorrect"),
        "error_email_already_exists":
            MessageLookupByLibrary.simpleMessage("Cet email est déjà utilisé"),
        "error_email_format":
            MessageLookupByLibrary.simpleMessage("Format d’email invalide"),
        "error_password_match": MessageLookupByLibrary.simpleMessage(
            "Les mots de passe ne correspondent pas"),
        "error_password_strength": MessageLookupByLibrary.simpleMessage(
            "Veillez à choisir un mot de passe plus fort"),
        "error_required_field":
            MessageLookupByLibrary.simpleMessage("Ce champ est obligatoire"),
        "error_unknown":
            MessageLookupByLibrary.simpleMessage("Une erreur est survenue"),
        "error_wrong_password":
            MessageLookupByLibrary.simpleMessage("Mot de passe incorrect"),
        "loading": MessageLookupByLibrary.simpleMessage("Chargement..."),
        "loginScreen_emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "loginScreen_forgotPasswordButton":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié ?"),
        "loginScreen_loginButton":
            MessageLookupByLibrary.simpleMessage("Se connecter"),
        "loginScreen_passwordLabel":
            MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "loginScreen_registerButton":
            MessageLookupByLibrary.simpleMessage("Créer un compte"),
        "loginScreen_rememberMeLabel":
            MessageLookupByLibrary.simpleMessage("Se souvenir de moi"),
        "myDashboard_title":
            MessageLookupByLibrary.simpleMessage("Mon tableau de bord"),
        "notFoundScreen_title":
            MessageLookupByLibrary.simpleMessage("Page introuvable"),
        "passwordStrength_0": MessageLookupByLibrary.simpleMessage("Faible"),
        "passwordStrength_1": MessageLookupByLibrary.simpleMessage("Faible"),
        "passwordStrength_2":
            MessageLookupByLibrary.simpleMessage("Acceptable"),
        "passwordStrength_3": MessageLookupByLibrary.simpleMessage("Fort"),
        "passwordStrength_4": MessageLookupByLibrary.simpleMessage("Fort")
      };
}
