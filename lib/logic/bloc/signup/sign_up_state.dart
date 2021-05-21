part of 'sign_up_bloc.dart';

class SignUpState {
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
    if (username.isEmpty) {
      return 'El usuario no puede ser vacío';
    }
    return null;
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
