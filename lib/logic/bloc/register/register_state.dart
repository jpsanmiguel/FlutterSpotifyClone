part of 'register_bloc.dart';

class RegisterState {
  final String email;
  final String password;
  final FormSubmissionState formSubmissionState;

  RegisterState({
    this.email = '',
    this.password = '',
    this.formSubmissionState = const InitialFormState(),
  });

  RegisterState copyWith({
    String email,
    String password,
    FormSubmissionState formSubmissionState,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
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
    if (password.length < 6) {
      return 'La contraseña debe ser de 6 o más caracteres';
    }
    return null;
  }
}
