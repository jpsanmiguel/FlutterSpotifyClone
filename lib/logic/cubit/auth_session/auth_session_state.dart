part of 'auth_session_cubit.dart';

@immutable
abstract class AuthSessionState extends Equatable {}

class UnkownSessionState extends AuthSessionState {
  @override
  List<Object> get props => [];
}

class UnauthenticatedSessionState extends AuthSessionState {
  @override
  List<Object> get props => [];
}

class AuthenticatedSessionState extends AuthSessionState {
  final User user;

  AuthenticatedSessionState({@required this.user});

  @override
  List<Object> get props => [user];
}
