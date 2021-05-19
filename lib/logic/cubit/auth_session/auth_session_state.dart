part of 'auth_session_cubit.dart';

@immutable
abstract class AuthSessionState {}

class UnkownSessionState extends AuthSessionState {}

class UnautheticatedSessionState extends AuthSessionState {}

class AuthenticatedSessionState extends AuthSessionState {
  final User user;

  AuthenticatedSessionState({@required this.user});
}
