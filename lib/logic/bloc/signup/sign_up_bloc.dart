import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';
import 'package:spotify_clone/utils/functions.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;
  final DataRepository dataRepository;

  SignUpBloc({
    @required this.authRepository,
    @required this.authCubit,
    @required this.dataRepository,
  }) : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpEmailChanged) {
      yield state.copyWith(
        email: event.email,
      );
    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(
        password: event.password,
      );
    } else if (event is SignUpUsernameChanged) {
      yield state.copyWith(
        username: event.username,
      );
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(
        formSubmissionState: FormSubmissionSubmitting(),
      );

      try {
        await authRepository.signUp(
          email: state.email,
          password: state.password,
          username: state.username,
        );

        authCubit.showConfirmSignUp(
          email: state.email,
          username: state.username,
          password: state.password,
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
