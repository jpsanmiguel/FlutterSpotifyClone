part of 'spotify_player_cubit.dart';

@immutable
abstract class SpotifyPlayerState {}

class SpotifyPlayerConnecting extends SpotifyPlayerState {}

class SpotifyPlayerError extends SpotifyPlayerState {
  final String error;

  SpotifyPlayerError({@required this.error});
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
