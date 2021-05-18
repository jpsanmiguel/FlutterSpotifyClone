import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;

  RegisterBloc({
    @required this.authRepository,
    @required this.authCubit,
  }) : super(RegisterState());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is RegisterPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is RegisterSubmitted) {
      yield state.copyWith(formSubmissionState: FormSubmissionSubmitting());

      try {
        await authRepository.register(
          email: state.email,
          password: state.password,
          username: 'Sanmi',
        );
        yield state.copyWith(formSubmissionState: FormSubmissionSuccess());
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
      } catch (e) {
        yield state.copyWith(formSubmissionState: FormSubmissionFailed(e));
      }
    }
  }
}
