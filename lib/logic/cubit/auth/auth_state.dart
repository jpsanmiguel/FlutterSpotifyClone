part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedInAuthState extends AuthState {
  final AuthCredentials authCredentials;

  LoggedInAuthState({@required this.authCredentials});

  @override
  List<Object> get props => [authCredentials];
}

class SignUpAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignedUpAuthState extends AuthState {
  final AuthCredentials authCredentials;

  SignedUpAuthState({@required this.authCredentials});

  @override
  List<Object> get props => [authCredentials];
}

class ConfirmSignUpAuthState extends AuthState {
  @override
  List<Object> get props => [];
}
