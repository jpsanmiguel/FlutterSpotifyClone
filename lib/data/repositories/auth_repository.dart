import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/constants.dart';
import 'package:spotify_clone/utils/functions.dart';
import 'package:spotify_clone/data/repositories/auth_repository_presenter.dart';

class AuthRepository implements AuthRepositoryPresenter {
  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value;
      return userId;
    } catch (e) {
      final userId = (await getSharedPreferences()).getString(USER_ID);
      if (userId != null) {
        return userId;
      } else {
        throw e;
      }
    }
  }

  @override
  Future<String> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: false),
      );

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> login({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email.trim(),
        password: password.trim(),
      );
      final userId = (await _getUserIdFromAttributes());
      (await getSharedPreferences()).setString(USER_ID, userId);
      return result.isSignedIn ? userId : null;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> signUp({
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

  @override
  Future<bool> confirmSignUp({
    @required String email,
    @required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email.trim(),
        confirmationCode: confirmationCode.trim(),
      );
      return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }
}
