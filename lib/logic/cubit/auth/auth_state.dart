part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginAuthState extends AuthState {}

class LoggedInAuthState extends AuthState {
  final AuthCredentials authCredentials;

  LoggedInAuthState({@required this.authCredentials});
}

class SignUpAuthState extends AuthState {}

class SignedUpAuthState extends AuthState {
  final AuthCredentials authCredentials;

  SignedUpAuthState({@required this.authCredentials});
}
