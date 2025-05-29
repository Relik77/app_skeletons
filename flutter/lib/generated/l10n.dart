// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mon Projet Flutter`
  String get app_title {
    return Intl.message(
      'Mon Projet Flutter',
      name: 'app_title',
      desc: 'Titre de l\'application',
      args: [],
    );
  }

  /// `Chargement...`
  String get loading {
    return Intl.message(
      'Chargement...',
      name: 'loading',
      desc: 'Texte affiché lors du chargement de données',
      args: [],
    );
  }

  /// `Page introuvable`
  String get notFoundScreen_title {
    return Intl.message(
      'Page introuvable',
      name: 'notFoundScreen_title',
      desc: 'Titre de la page introuvable',
      args: [],
    );
  }

  /// `Email`
  String get loginScreen_emailLabel {
    return Intl.message(
      'Email',
      name: 'loginScreen_emailLabel',
      desc: 'Libellé pour l\'email',
      args: [],
    );
  }

  /// `Mot de passe`
  String get loginScreen_passwordLabel {
    return Intl.message(
      'Mot de passe',
      name: 'loginScreen_passwordLabel',
      desc: 'Libellé pour le mot de passe',
      args: [],
    );
  }

  /// `Se connecter`
  String get loginScreen_loginButton {
    return Intl.message(
      'Se connecter',
      name: 'loginScreen_loginButton',
      desc: 'Texte du bouton pour se connecter',
      args: [],
    );
  }

  /// `Se souvenir de moi`
  String get loginScreen_rememberMeLabel {
    return Intl.message(
      'Se souvenir de moi',
      name: 'loginScreen_rememberMeLabel',
      desc: 'Libellé pour se souvenir de l\'utilisateur',
      args: [],
    );
  }

  /// `Mot de passe oublié ?`
  String get loginScreen_forgotPasswordButton {
    return Intl.message(
      'Mot de passe oublié ?',
      name: 'loginScreen_forgotPasswordButton',
      desc: 'Texte du bouton pour mot de passe oublié',
      args: [],
    );
  }

  /// `Créer un compte`
  String get loginScreen_registerButton {
    return Intl.message(
      'Créer un compte',
      name: 'loginScreen_registerButton',
      desc: 'Texte du bouton pour créer un compte',
      args: [],
    );
  }

  /// `Mon compte`
  String get account_title {
    return Intl.message(
      'Mon compte',
      name: 'account_title',
      desc: 'Titre de la page de compte',
      args: [],
    );
  }

  /// `Mon tableau de bord`
  String get myDashboard_title {
    return Intl.message(
      'Mon tableau de bord',
      name: 'myDashboard_title',
      desc: 'Titre de la page du tableau de bord',
      args: [],
    );
  }

  /// `Faible`
  String get passwordStrength_0 {
    return Intl.message(
      'Faible',
      name: 'passwordStrength_0',
      desc: 'Texte pour un mot de passe faible',
      args: [],
    );
  }

  /// `Faible`
  String get passwordStrength_1 {
    return Intl.message(
      'Faible',
      name: 'passwordStrength_1',
      desc: 'Texte pour un mot de passe faible',
      args: [],
    );
  }

  /// `Acceptable`
  String get passwordStrength_2 {
    return Intl.message(
      'Acceptable',
      name: 'passwordStrength_2',
      desc: 'Texte pour un mot de passe acceptable',
      args: [],
    );
  }

  /// `Fort`
  String get passwordStrength_3 {
    return Intl.message(
      'Fort',
      name: 'passwordStrength_3',
      desc: 'Texte pour un mot de passe fort',
      args: [],
    );
  }

  /// `Fort`
  String get passwordStrength_4 {
    return Intl.message(
      'Fort',
      name: 'passwordStrength_4',
      desc: 'Texte pour un mot de passe fort',
      args: [],
    );
  }

  /// `Ce champ est obligatoire`
  String get error_required_field {
    return Intl.message(
      'Ce champ est obligatoire',
      name: 'error_required_field',
      desc: 'Message d\'erreur pour un champ obligatoire',
      args: [],
    );
  }

  /// `Email ou mot de passe incorrect`
  String get error_account_not_found {
    return Intl.message(
      'Email ou mot de passe incorrect',
      name: 'error_account_not_found',
      desc: 'Message d\'erreur pour un compte introuvable',
      args: [],
    );
  }

  /// `Mot de passe incorrect`
  String get error_wrong_password {
    return Intl.message(
      'Mot de passe incorrect',
      name: 'error_wrong_password',
      desc: 'Message d\'erreur pour un mot de passe incorrect',
      args: [],
    );
  }

  /// `Les mots de passe ne correspondent pas`
  String get error_password_match {
    return Intl.message(
      'Les mots de passe ne correspondent pas',
      name: 'error_password_match',
      desc: 'Message d\'erreur pour des mots de passe non identiques',
      args: [],
    );
  }

  /// `Veillez à choisir un mot de passe plus fort`
  String get error_password_strength {
    return Intl.message(
      'Veillez à choisir un mot de passe plus fort',
      name: 'error_password_strength',
      desc: 'Message d\'erreur pour un mot de passe trop faible',
      args: [],
    );
  }

  /// `Cet email est déjà utilisé`
  String get error_email_already_exists {
    return Intl.message(
      'Cet email est déjà utilisé',
      name: 'error_email_already_exists',
      desc: 'Message d\'erreur pour un email déjà existant',
      args: [],
    );
  }

  /// `Format d’email invalide`
  String get error_email_format {
    return Intl.message(
      'Format d’email invalide',
      name: 'error_email_format',
      desc: 'Message d\'erreur pour un email invalide',
      args: [],
    );
  }

  /// `Une erreur est survenue`
  String get error_unknown {
    return Intl.message(
      'Une erreur est survenue',
      name: 'error_unknown',
      desc: 'Message d\'erreur pour une erreur inconnue',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
