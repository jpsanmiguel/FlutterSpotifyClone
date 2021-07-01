part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final FormSubmissionState formSubmissionState;

  LoginState({
    this.email = '',
    this.password = '',
    this.formSubmissionState = const InitialFormState(),
  });

  LoginState copyWith({
    String email,
    String password,
    FormSubmissionState formSubmissionState,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }

  String validateEmail(String email) {
    return validateEmailUtils(email);
  }

  String validatePassword(String password) {
    return validatePasswordUtils(password);
  }

  @override
  List<Object> get props => [email, password, formSubmissionState];
}
