import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/auth_repository.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc({@required this.authRepository}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formSubmissionState: FormSubmissionSubmitting());

      try {
        await authRepository.login();
        yield state.copyWith(formSubmissionState: FormSubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formSubmissionState: FormSubmissionFailed(e));
      }
    }
  }
}
