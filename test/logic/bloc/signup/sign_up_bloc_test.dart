import 'package:bloc_test/bloc_test.dart' as blocTest;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_clone/logic/bloc/signup/sign_up_bloc.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

import '../../../mocks/mock_auth_cubit.dart';
import '../../../mocks/mock_auth_repository.dart';
import '../../../mocks/mock_data_repository.dart';

void main() {
  MockAuthRepository mockAuthRepository;
  MockAuthCubit mockAuthCubit;
  MockDataRepository mockDataRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthCubit = MockAuthCubit();
    mockDataRepository = MockDataRepository();
  });

  group('Username changed', () {
    blocTest.blocTest(
      'Changed username',
      build: () => SignUpBloc(
        authRepository: mockAuthRepository,
        authCubit: mockAuthCubit,
        dataRepository: mockDataRepository,
      ),
      act: (bloc) {
        bloc
          ..add(SignUpUsernameChanged(username: 'Sa'))
          ..add(SignUpUsernameChanged(username: 'Sanmi'))
          ..add(SignUpUsernameChanged(username: ''))
          ..add(SignUpUsernameChanged(username: 'Sanmi00'));
      },
      expect: () => [
        SignUpState(username: 'Sa'),
        SignUpState(username: 'Sanmi'),
        SignUpState(username: ''),
        SignUpState(username: 'Sanmi00'),
      ],
    );
  });

  group('Email changed', () {
    blocTest.blocTest(
      'Changed email',
      build: () => SignUpBloc(
        authRepository: mockAuthRepository,
        authCubit: mockAuthCubit,
        dataRepository: mockDataRepository,
      ),
      act: (bloc) {
        bloc
          ..add(SignUpEmailChanged(email: 'correo'))
          ..add(SignUpEmailChanged(email: 'correo@'))
          ..add(SignUpEmailChanged(email: 'correo@gmail'))
          ..add(SignUpEmailChanged(email: 'correo@gmail.com'));
      },
      expect: () => [
        SignUpState(email: 'correo'),
        SignUpState(email: 'correo@'),
        SignUpState(email: 'correo@gmail'),
        SignUpState(email: 'correo@gmail.com'),
      ],
    );
  });

  group('Password changed', () {
    blocTest.blocTest(
      'Changed password',
      build: () => SignUpBloc(
        authRepository: mockAuthRepository,
        authCubit: mockAuthCubit,
        dataRepository: mockDataRepository,
      ),
      act: (bloc) {
        bloc
          ..add(SignUpEmailChanged(email: 'pa'))
          ..add(SignUpEmailChanged(email: 'pass'))
          ..add(SignUpEmailChanged(email: 'passwo'))
          ..add(SignUpEmailChanged(email: 'password'));
      },
      expect: () => [
        SignUpState(email: 'pa'),
        SignUpState(email: 'pass'),
        SignUpState(email: 'passwo'),
        SignUpState(email: 'password'),
      ],
    );
  });

  group('Sign up form submitted', () {
    blocTest.blocTest(
      'Submission success',
      build: () {
        when(mockAuthRepository.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          username: anyNamed('username'),
        )).thenAnswer((_) async => false);
        return SignUpBloc(
          authRepository: mockAuthRepository,
          authCubit: mockAuthCubit,
          dataRepository: mockDataRepository,
        );
      },
      act: (bloc) {
        bloc
          ..add(SignUpUsernameChanged(username: 'username'))
          ..add(SignUpEmailChanged(email: 'email'))
          ..add(SignUpPasswordChanged(password: 'password'))
          ..add(SignUpSubmitted());
      },
      expect: () => [
        SignUpState(
          username: 'username',
        ),
        SignUpState(
          username: 'username',
          email: 'email',
        ),
        SignUpState(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
        SignUpState(
          username: 'username',
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionSubmitting(),
        ),
        SignUpState(
          username: 'username',
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionSuccess(),
        ),
      ],
    );

    blocTest.blocTest(
      'Submission failed',
      build: () {
        when(mockAuthRepository.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          username: anyNamed('username'),
        )).thenThrow(Exception());
        return SignUpBloc(
          authRepository: mockAuthRepository,
          authCubit: mockAuthCubit,
          dataRepository: mockDataRepository,
        );
      },
      act: (bloc) {
        bloc
          ..add(SignUpUsernameChanged(username: 'username'))
          ..add(SignUpEmailChanged(email: 'email'))
          ..add(SignUpPasswordChanged(password: 'password'))
          ..add(SignUpSubmitted());
      },
      expect: () => [
        SignUpState(
          username: 'username',
        ),
        SignUpState(
          username: 'username',
          email: 'email',
        ),
        SignUpState(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
        SignUpState(
          username: 'username',
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionSubmitting(),
        ),
        SignUpState(
          username: 'username',
          email: 'email',
          password: 'password',
          formSubmissionState: FormSubmissionFailed(),
        ),
      ],
    );
  });
}
