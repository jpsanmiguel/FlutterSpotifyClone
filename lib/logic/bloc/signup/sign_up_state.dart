part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final String email;
  final String password;
  final String username;
  final FormSubmissionState formSubmissionState;

  SignUpState({
    this.email = '',
    this.password = '',
    this.username = '',
    this.formSubmissionState = const InitialFormState(),
  });

  SignUpState copyWith({
    String email,
    String password,
    String username,
    FormSubmissionState formSubmissionState,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }

  String validateUsername(String username) {
    return validateUsernameUtils(username);
  }

  String validateEmail(String email) {
    return validateEmailUtils(email);
  }

  String validatePassword(String password) {
    return validatePasswordUtils(password);
  }

  @override
  List<Object> get props => [email, password, username, formSubmissionState];
}
