part of 'session_cubit.dart';

@immutable
abstract class SessionState {}

class UnkownSessionState extends SessionState {}

class UnautheticatedSessionState extends SessionState {}

class AuthenticatedSessionState extends SessionState {
  final User user;

  AuthenticatedSessionState({@required this.user});
}
