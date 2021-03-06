import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';
import 'package:spotify_clone/utils/functions.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;

  LoginBloc({
    @required this.authRepository,
    @required this.authCubit,
  }) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield state.copyWith(
        email: event.email,
      );
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(
        password: event.password,
      );
    } else if (event is LoginSubmitted) {
      yield state.copyWith(
        formSubmissionState: FormSubmissionSubmitting(),
      );

      try {
        final userId = await authRepository.login(
          email: state.email,
          password: state.password,
        );

        authCubit.launchSession(
          AuthCredentials(
            email: state.email,
            userId: userId,
          ),
        );

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
