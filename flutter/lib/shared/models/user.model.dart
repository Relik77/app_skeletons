
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sample_project/shared/utils.dart';

class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final String type;
  final DateTime expiresAt;

  int get expiresIn => expiresAt.difference(DateTime.now()).inSeconds;
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isAboutToExpire => DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
  String get token => '$type $accessToken';

  AuthToken({
    required this.accessToken,
    this.refreshToken,
    required this.type,
    required this.expiresAt,
  });

  factory AuthToken.fromJson(JSON json) {
    final accessToken = json['accessToken'] as JSON;
    final DateTime expiresAt;
    if (accessToken['expires_at'] is String) {
      expiresAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(accessToken['expires_at'] as String);
    } else {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(accessToken['expires_at'] as int);
    }
    return AuthToken(
      accessToken: accessToken['access_token'] as String,
      refreshToken: json['refreshToken'] as String?,
      type: accessToken['token_type'] as String,
      expiresAt: expiresAt,
    );
  }

  JSON toJson() {
    return {
      "accessToken": {
        "access_token": accessToken,
        "token_type": type,
        "expires_at": expiresAt.toIso8601String(),
      },
      if (!kIsWeb) "refreshToken": refreshToken, // Not saved on web because it's not secure
    };
  }

  @override
  String toString() {
    return 'AuthToken{accessToken: $accessToken, refreshToken: $refreshToken, type: $type, expiresIn: $expiresIn, expiresAt: $expiresAt}';
  }
}

class User {
  int id;
  String? email;
  bool? emailVerified;
  String? nickname;
  String? firstName;
  String? lastName;
  String? picture;
  String? description;
  String? language;
  String? country;
  String? timezone;
  bool isOnline;

  String get shortName {
    if (firstName?.isNotEmpty == true) {
      return firstName!;
    } else if (lastName?.isNotEmpty == true) {
      return lastName!;
    } else if (nickname?.isNotEmpty == true) {
      return nickname!;
    } else if (email?.isNotEmpty == true) {
      return email!.split('@').first.replaceAll(RegExp(r'[._]'), " ");
    } else {
      return "";
    }
  }

  String get fullName {
    if (firstName?.isNotEmpty == true && lastName?.isNotEmpty == true) {
      return "$firstName $lastName";
    }
    return shortName;
  }

  User({
    required this.id,
    this.email,
    this.emailVerified,
    this.nickname,
    this.firstName,
    this.lastName,
    this.picture,
    this.description,
    this.language,
    this.country,
    this.timezone,
    this.isOnline = false,
  });

  factory User.fromJson(JSON json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String?,
      emailVerified: json['email_verified_at'] != null,
      nickname: (json['nickname'] is String) ? capitalize(json['nickname']) : null,
      firstName: (json['first_name'] is String) ? capitalize(json['first_name']) : null,
      lastName: (json['last_name'] is String) ? capitalize(json['last_name']) : null,
      picture: json['picture'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
      country: json['country'] as String?,
      timezone: json['timezone'] as String?,
      isOnline: isTrue(json['connected']),
    );
  }

  JSON toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "description": description,
      "language": language,
      "country": country,
      "timezone": timezone,
    };
  }

  @override
  String toString() {
    return 'User{firstName: $firstName, lastName: $lastName, email: $email}';
  }
}

class AuthUser extends User {
  AuthToken? authToken;
  String? currentPassword;
  String? newPassword;
  bool requireUpdatePassword;

  Map<String, String> get authorizationHeaders {
    final token = authToken?.token;
    return {
      if (token != null) 'Authorization': token,
    };
  }

  AuthUser({
    required super.id,
    super.email,
    super.emailVerified,
    super.firstName,
    super.lastName,
    super.picture,
    super.description,
    super.language,
    super.country,
    super.timezone,
    this.authToken,
    this.requireUpdatePassword = false,
  });

  factory AuthUser.fromJson(JSON json) {
    return AuthUser(
      id: json['id'] as int,
      email: json['email'] as String?,
      emailVerified: json['email_verified_at'] != null,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      picture: json['picture'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
      country: json['country'] as String?,
      timezone: json['timezone'] as String?,
      requireUpdatePassword: json['force_password_change'] == 1,
    );
  }

  @override
  JSON toJson() {
    return {
      ...super.toJson(),
      if (currentPassword != null) 'current_password': currentPassword!,
      if (newPassword != null) 'new_password': newPassword!,
    };
  }

  @override
  String toString() {
    return 'AuthUser{firstName: $firstName, lastName: $lastName, email: $email, description: $description, currentPassword: $currentPassword, newPassword: $newPassword}';
  }
}
