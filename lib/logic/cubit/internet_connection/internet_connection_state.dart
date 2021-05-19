part of 'internet_connection_cubit.dart';

@immutable
abstract class InternetConnectionState {}

class InternetConnectionInitial extends InternetConnectionState {}

class InternetConnectedState extends InternetConnectionState {
  final ConnectionType connectionType;

  InternetConnectedState({@required this.connectionType});
}

class InternetDisconnectedState extends InternetConnectionState {}
