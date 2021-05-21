part of 'spotify_player_bloc.dart';

class SpotifyPlayerState {
  final SpotifyPlayerConnectionStatus connectionStatus;
  final SpotifyPlayerReproductionStatus reproductionStatus;
  final Track track;
  final String error;

  SpotifyPlayerState({
    this.connectionStatus,
    this.reproductionStatus,
    this.track,
    this.error,
  });

  SpotifyPlayerState copyWith({
    SpotifyPlayerConnectionStatus connectionStatus,
    SpotifyPlayerReproductionStatus reproductionStatus,
    Track track,
    String error,
  }) {
    return SpotifyPlayerState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      reproductionStatus: reproductionStatus ?? this.reproductionStatus,
      track: track ?? this.track,
      error: error,
    );
  }
}
