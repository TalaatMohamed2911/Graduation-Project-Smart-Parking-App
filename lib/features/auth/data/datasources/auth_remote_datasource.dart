import '../../../../core/services/auth_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> signup(String fullname, String email, String password);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final RemoteAuthService _remoteAuthService;

  AuthRemoteDataSourceImpl(this._remoteAuthService);

  @override
  Future<User> login(String email, String password) {
    return _remoteAuthService.login(email, password);
  }

  @override
  Future<User> signup(String fullname, String email, String password) {
    return _remoteAuthService.signup(fullname, email, password);
  }

  @override
  Future<void> logout() {
    return _remoteAuthService.logout();
  }
}
