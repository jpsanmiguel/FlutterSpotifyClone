import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/auth_repository.dart';
import 'package:spotify_clone/logic/form_submission_state.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  RegisterBloc({@required this.authRepository}) : super(RegisterState());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is RegisterPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is RegisterSubmitted) {
      yield state.copyWith(formSubmissionState: FormSubmissionSubmitting());

      try {
        await authRepository.register();
        yield state.copyWith(formSubmissionState: FormSubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formSubmissionState: FormSubmissionFailed(e));
      }
    }
  }
}
