part of 'spotify_connection_cubit.dart';

@immutable
abstract class SpotifyPlayerState {}

class SpotifyPlayerInitial extends SpotifyPlayerState {}

class SpotifyPlayerConnecting extends SpotifyPlayerState {}

class SpotifyPlayerConnectionFailed extends SpotifyPlayerState {}

class SpotifyPlayerConnected extends SpotifyPlayerState {}

class SpotifyPlayerPlaying extends SpotifyPlayerState {
  final Track track;

  SpotifyPlayerPlaying({@required this.track});
}

class SpotifyPlayerPaused extends SpotifyPlayerState {
  final Track track;

  SpotifyPlayerPaused({@required this.track});
}
