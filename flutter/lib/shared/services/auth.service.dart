
import 'package:logging/logging.dart';
import 'package:sample_project/shared/models/user.model.dart';

enum LoginError { accountNotFound, wrongPassword, emailAlreadyExists, unknown }

class AuthService {
  static AuthService instance = AuthService();
  final _log = Logger("AuthService");

  Future<AuthUser> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    return AuthUser(id: 1);
    // try {
    //   final response = await apiService.post(path: ApiConfig.login, body: {
    //     "type": "password",
    //     "login": email,
    //     "password": password,
    //   });
    //   final authToken = AuthToken.fromJson(response.body);
    //   apiService.setAuthorizationToken(authToken.token);
    //   saveAuthToken(authToken);
    //
    //   final user = await getProfile();
    //   user.authToken = authToken;
    //   return user;
    // } catch (e) {
    //   _log.severe("Error while logging in", e);
    //   throw LoginError.accountNotFound;
    // }
  }

  Future<void> logout() async {
    // saveAuthToken(null);
    // return apiService.get(path: ApiConfig.logout).then((value) => apiService.setAuthorizationToken(null));
  }
}