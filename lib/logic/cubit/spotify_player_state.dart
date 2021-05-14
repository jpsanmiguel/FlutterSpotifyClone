part of 'spotify_player_cubit.dart';

@immutable
abstract class SpotifyPlayerState {}

class SpotifyPlayerInitial extends SpotifyPlayerState {}

class SpotifyPlayerConnecting extends SpotifyPlayerState {}

class SpotifyPlayerConnectionFailed extends SpotifyPlayerState {
  final String error;

  SpotifyPlayerConnectionFailed({@required this.error});
}

class SpotifyPlayerConnected extends SpotifyPlayerState {}

class SpotifyPlayerPlaying extends SpotifyPlayerState {
  final Track track;

  SpotifyPlayerPlaying({@required this.track});
}

class SpotifyPlayerPaused extends SpotifyPlayerState {
  final Track track;

  SpotifyPlayerPaused({@required this.track});
}

class SpotifyPlayerLoading extends SpotifyPlayerState {}

class SpotifyPlayerNotConnected extends SpotifyPlayerState {}
