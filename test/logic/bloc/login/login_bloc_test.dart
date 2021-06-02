import 'package:bloc_test/bloc_test.dart' as blocTest;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_clone/logic/bloc/login/login_bloc.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

import '../../../mocks/mock_auth_cubit.dart';
import '../../../mocks/mock_auth_repository.dart';

void main() {
  MockAuthRepository mockAuthRepository;
  MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthCubit = MockAuthCubit();
  });

  group('Email changed', () {
    blocTest.blocTest(
      'Changed email',
      build: () => LoginBloc(
        authRepository: mockAuthRepository,
        authCubit: mockAuthCubit,
      ),
      act: (bloc) {
        bloc
          ..add(LoginEmailChanged(email: 'correo'))
          ..add(LoginEmailChanged(email: 'correo@'))
          ..add(LoginEmailChanged(email: 'correo@gmail'))
          ..add(LoginEmailChanged(email: 'correo@gmail.com'));
      },
      expect: () => [
        LoginState(email: 'correo'),
        LoginState(email: 'correo@'),
        LoginState(email: 'correo@gmail'),
        LoginState(email: 'correo@gmail.com'),
      ],
    );
  });

  group('Password changed', () {
    blocTest.blocTest(
      'Changed password',
      build: () => LoginBloc(
        authRepository: mockAuthRepository,
        authCubit: mockAuthCubit,
      ),
      act: (bloc) {
        bloc
          ..add(LoginEmailChanged(email: 'pa'))
          ..add(LoginEmailChanged(email: 'pass'))
          ..add(LoginEmailChanged(email: 'passwo'))
          ..add(LoginEmailChanged(email: 'password'));
      },
      expect: () => [
        LoginState(email: 'pa'),
        LoginState(email: 'pass'),
        LoginState(email: 'passwo'),
        LoginState(email: 'password'),
      ],
    );
  });

  group('Login form submitted', () {
    blocTest.blocTest(
      'Submission success',
      build: () {
        when(mockAuthRepository.login(
                email: anyNamed('email'), password: anyNamed('password')))
            .thenAnswer((_) async => '123456');
        return LoginBloc(
          authRepository: mockAuthRepository,
          authCubit: mockAuthCubit,
        );
      },
      act: (bloc) {
        bloc
          ..add(LoginEmailChanged(email: 'email'))
          ..add(LoginPasswordChanged(password: 'password'))
          ..add(LoginSubmitted());
      },
      expect: () => [
        LoginState(email: 'email'),
        LoginState(email: 'email', password: 'password'),
        LoginState(
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionSubmitting(),
        ),
        LoginState(
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionSuccess(),
        ),
      ],
    );

    blocTest.blocTest(
      'Submission failed',
      build: () {
        when(mockAuthRepository.login(email: 'email', password: 'password'))
            .thenThrow(Exception());
        return LoginBloc(
          authRepository: mockAuthRepository,
          authCubit: mockAuthCubit,
        );
      },
      act: (bloc) {
        bloc
          ..add(LoginEmailChanged(email: 'email'))
          ..add(LoginPasswordChanged(password: 'password'))
          ..add(LoginSubmitted());
      },
      expect: () => [
        LoginState(email: 'email'),
        LoginState(email: 'email', password: 'password'),
        LoginState(
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionSubmitting(),
        ),
        LoginState(
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionFailed(),
        ),
      ],
    );
  });
}
