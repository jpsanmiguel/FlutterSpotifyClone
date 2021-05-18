import 'package:flutter/material.dart';

class AuthRepository {
  Future<String> attemptAutoLogin() async {
    await Future.delayed(Duration(seconds: 3));
    throw Exception('not signed in');
  }

  Future<String> login({
    @required String email,
    @required String password,
  }) async {
    print('attempting login');
    await Future.delayed(
      Duration(seconds: 3),
    );
    return 'logged in!';
  }

  Future<String> register({
    @required String email,
    @required String password,
  }) async {
    print('attempting register');
    await Future.delayed(
      Duration(seconds: 3),
    );
    return 'registered!';
  }

  Future<void> signOut() async {
    await Future.delayed(
      Duration(seconds: 2),
    );
  }
}
