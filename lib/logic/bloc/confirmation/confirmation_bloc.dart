import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:spotify_clone/data/repositories/auth_repository_presenter.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepositoryPresenter authRepository;
  final AuthCubit authCubit;

  ConfirmationBloc({
    @required this.authRepository,
    @required this.authCubit,
  }) : super(ConfirmationState());

  @override
  Stream<ConfirmationState> mapEventToState(
    ConfirmationEvent event,
  ) async* {
    if (event is ConfirmationCodeChanged) {
      yield state.copyWith(
        code: event.code,
      );
    } else if (event is ConfirmationSubmitted) {
      yield state.copyWith(
        formSubmissionState: FormSubmissionSubmitting(),
      );

      try {
        await authRepository.confirmSignUp(
          email: authCubit.credentials.email,
          confirmationCode: state.code,
        );

        final credentials = authCubit.credentials;
        final userId = await authRepository.login(
          email: credentials.email,
          password: credentials.password,
        );
        credentials.userId = userId;

        authCubit.launchSession(credentials);

        yield state.copyWith(
          formSubmissionState: FormSubmissionSuccess(),
        );
      } on Exception {
        yield state.copyWith(
          formSubmissionState: FormSubmissionFailed(),
        );
      }
    }
  }
}
