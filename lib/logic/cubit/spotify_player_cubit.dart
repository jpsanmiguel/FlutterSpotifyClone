import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

part 'spotify_player_state.dart';

class SpotifyPlayerCubit extends Cubit<SpotifyPlayerState> {
  final Repository repository;

  SpotifyPlayerCubit({@required this.repository})
      : super(SpotifyPlayerInitial());

  bool connected = false;

  void connectToSpotifyRemote() async {
    if (!connected) {
      emit(SpotifyPlayerConnecting());
      try {
        connected = await repository.connectToSpotifyRemote();
        if (connected) {
          emit(SpotifyPlayerConnected());
        } else {
          emit(SpotifyPlayerConnectionFailed(
              error: 'No se pudo conectar al reproductor de Spotify.'));
        }
      } on PlatformException catch (e) {
        emit(SpotifyPlayerConnectionFailed(error: e.message));
      }
    }
  }

  void play(Track track) async {
    if (connected) {
      await repository.play(track);
    } else {
      await connectToSpotifyRemote();
      play(track);
    }
  }

  void pause(Track track) async {
    if (connected) {
      await repository.pause();
    } else {
      await connectToSpotifyRemote();
      pause(track);
    }
  }

  void resume(Track track) async {
    if (connected) {
      await repository.resume();
    } else {
      await connectToSpotifyRemote();
      resume(track);
    }
  }

  void listenToPlayerState() {
    Stream stream = SpotifySdk.subscribePlayerState();
    stream.listen((playerState) {
      if (playerState != null && playerState is PlayerState) {
        if (playerState.track != null) {
          if (playerState.isPaused) {
            emit(SpotifyPlayerPaused(
                track: Track.fromSpotifySdkTrack(playerState.track)));
          } else {
            emit(SpotifyPlayerPlaying(
                track: Track.fromSpotifySdkTrack(playerState.track)));
          }
        } else {
          emit(SpotifyPlayerLoading());
        }
      } else {
        emit(SpotifyPlayerInitial());
      }
    });
  }

  void stateNotConnected() {
    emit(SpotifyPlayerNotConnected());
  }

  void errorPlayingTrack(String error) {
    emit(SpotifyPlayerConnectionFailed(error: error));
  }
}
