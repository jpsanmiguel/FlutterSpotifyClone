import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';

void main() {
  group('AuthCubit', () {
    AuthCubit authCubit;
    AuthCredentials authCredentials;

    setUp(() {
      authCubit = AuthCubit();
      authCredentials = AuthCredentials(
        email: '',
        password: '',
        userId: '',
        username: '',
      );
    });

    tearDown(() {
      authCubit.close();
    });

    test('Initial state of AuthCubit is AuthInitial', () {
      expect(authCubit.state, AuthInitial());
    });

    blocTest(
      'Should emit LoginAuthState when showLogin function is called',
      build: () => authCubit,
      act: (cubit) => cubit.showLogin(),
      expect: () => [LoginAuthState()],
    );

    blocTest(
      'Should emit SignUpAuthState when showSignUp function is called',
      build: () => authCubit,
      act: (cubit) => cubit.showSignUp(),
      expect: () => [SignUpAuthState()],
    );

    blocTest(
      'Should emit LoggedInAuthState when launchSession function is called',
      build: () => authCubit,
      act: (cubit) => cubit.launchSession(authCredentials),
      expect: () => [
        LoggedInAuthState(
          authCredentials: authCredentials,
        )
      ],
    );

    blocTest(
      'Should emit ConfirmSignUpAuthState when showConfirmSignUp function is called',
      build: () => authCubit,
      act: (cubit) => cubit.showConfirmSignUp(
        username: '',
        email: '',
        password: '',
      ),
      expect: () => [ConfirmSignUpAuthState()],
    );
  });
}
