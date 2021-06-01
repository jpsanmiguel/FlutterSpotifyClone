import 'package:flutter/foundation.dart';

abstract class AuthRepositoryPresenter {
  Future<String> attemptAutoLogin();
  Future<String> login({
    @required String email,
    @required String password,
  });
  Future<bool> signUp({
    @required String email,
    @required String password,
    @required String username,
  });
  Future<bool> confirmSignUp({
    @required String email,
    @required String confirmationCode,
  });
  Future<void> signOut();
}
