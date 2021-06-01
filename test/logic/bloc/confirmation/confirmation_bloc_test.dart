import 'package:bloc_test/bloc_test.dart' as blocTest;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/logic/bloc/confirmation/confirmation_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

import '../../../mocks/mock_auth_repository.dart';

void main() {
  MockAuthRepository mockAuthRepository;
  AuthCubit authCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit();
  });

  group('Confirmation code changed', () {
    blocTest.blocTest(
      'Changed confirmation code',
      build: () => ConfirmationBloc(
        authRepository: mockAuthRepository,
        authCubit: authCubit,
      ),
      act: (bloc) {
        bloc
          ..add(ConfirmationCodeChanged(code: '1'))
          ..add(ConfirmationCodeChanged(code: '123456'));
      },
      expect: () => [
        ConfirmationState(code: '1'),
        ConfirmationState(code: '123456'),
      ],
    );
  });

  group('Confirmation code submitted', () {
    blocTest.blocTest(
      'Submission success',
      build: () {
        authCubit.credentials = AuthCredentials(email: 'email');
        when(mockAuthRepository.confirmSignUp(
          email: anyNamed('email'),
          confirmationCode: '123456',
        )).thenAnswer((_) async {
          return true;
        });
        return ConfirmationBloc(
          authRepository: mockAuthRepository,
          authCubit: authCubit,
        );
      },
      act: (bloc) {
        bloc
          ..add(ConfirmationCodeChanged(code: '123456'))
          ..add(ConfirmationSubmitted());
      },
      expect: () => [
        ConfirmationState(code: '123456'),
        ConfirmationState(
          code: '123456',
          formSubmissionState: FormSubmissionSubmitting(),
        ),
        ConfirmationState(
          code: '123456',
          formSubmissionState: FormSubmissionSuccess(),
        ),
      ],
    );

    blocTest.blocTest(
      'Submission failed',
      build: () {
        authCubit.credentials = AuthCredentials(email: 'email');
        when(mockAuthRepository.confirmSignUp(
          email: 'email',
          confirmationCode: '123456',
        )).thenThrow(Exception());
        return ConfirmationBloc(
          authRepository: mockAuthRepository,
          authCubit: authCubit,
        );
      },
      act: (bloc) {
        bloc
          ..add(ConfirmationCodeChanged(code: '123456'))
          ..add(ConfirmationSubmitted());
      },
      expect: () => [
        ConfirmationState(code: '123456'),
        ConfirmationState(
          code: '123456',
          formSubmissionState: FormSubmissionSubmitting(),
        ),
        ConfirmationState(
          code: '123456',
          formSubmissionState: FormSubmissionFailed(),
        ),
      ],
    );
  });
}
