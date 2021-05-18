part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({this.password});
}

class SignUpUsernameChanged extends SignUpEvent {
  final String username;

  SignUpUsernameChanged({this.username});
}

class SignUpSubmitted extends SignUpEvent {}
