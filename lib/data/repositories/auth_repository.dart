import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value;
      return userId;
    } catch (e) {
      throw e;
    }
  }

  Future<String> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  Future<String> login({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email.trim(),
        password: password.trim(),
      );

      return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> register({
    @required String email,
    @required String password,
    @required String username,
  }) async {
    final options = CognitoSignUpOptions(
      userAttributes: {
        'email': email.trim(),
      },
    );
    try {
      final result = await Amplify.Auth.signUp(
        username: email.trim(),
        password: password.trim(),
        options: options,
      );

      return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }
}
