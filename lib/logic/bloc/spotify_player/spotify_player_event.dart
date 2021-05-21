part of 'spotify_player_bloc.dart';

@immutable
abstract class SpotifyPlayerEvent {}

class SpotifyPlayerConnect extends SpotifyPlayerEvent {}

class SpotifyPlayerConnected extends SpotifyPlayerEvent {
  final Track track;
  final SpotifyPlayerReproductionStatus reproductionStatus;

  SpotifyPlayerConnected({
    @required this.track,
    @required this.reproductionStatus,
  });
}

class SpotifyPlayerPlay extends SpotifyPlayerEvent {
  final Track track;

  SpotifyPlayerPlay({@required this.track});
}

class SpotifyPlayerPause extends SpotifyPlayerEvent {
  final Track track;

  SpotifyPlayerPause({@required this.track});
}

class SpotifyPlayerResume extends SpotifyPlayerEvent {}

class SpotifyPlayerLoading extends SpotifyPlayerEvent {}

class SpotifyPlayerError extends SpotifyPlayerEvent {
  final String error;

  SpotifyPlayerError({@required this.error});
}
