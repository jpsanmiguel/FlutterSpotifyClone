part of 'login_bloc.dart';

class LoginState {
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
      formSubmissionState: formSubmissionState,
    );
  }

  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'El correo no puede ser vacío';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return 'Debes ingresar un correo válido';
    }
    return null;
  }

  String validatePassword(String password) {
    if (password.length < 8) {
      return 'La contraseña debe ser de 8 o más caracteres';
    }
    return null;
  }
}
