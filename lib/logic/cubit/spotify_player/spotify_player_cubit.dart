import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

part 'spotify_player_state.dart';

class SpotifyPlayerCubit extends Cubit<SpotifyPlayerState> {
  final SpotifyRepository spotifyRepository;

  SpotifyPlayerCubit({@required this.spotifyRepository})
      : super(SpotifyPlayerConnecting()) {
    connectToSpotifyRemote();
  }

  bool connected = false;
  Track track;

  void connectToSpotifyRemote() async {
    if (!connected) {
      emit(SpotifyPlayerConnecting());
      try {
        connected = await spotifyRepository.connectToSpotifyRemote();
        if (connected) {
          listenToPlayerState();
          emit(SpotifyPlayerConnected());
        } else {
          emit(SpotifyPlayerError(
              error: 'No se pudo conectar al reproductor de Spotify.'));
        }
      } on PlatformException catch (e) {
        emit(SpotifyPlayerError(error: e.message));
      }
    }
  }

  void play(Track track) async {
    if (connected) {
      this.track = track;
      await spotifyRepository.play(track);
    } else {
      emit(SpotifyPlayerError(error: 'Not connected to spotify!'));
    }
  }

  void pause() async {
    if (connected) {
      await spotifyRepository.pause();
    } else {
      emit(SpotifyPlayerError(error: 'Not connected to spotify!'));
    }
  }

  void resume() async {
    if (connected) {
      await spotifyRepository.resume();
    } else {
      emit(SpotifyPlayerError(error: 'Not connected to spotify!'));
    }
  }

  void listenToPlayerState() async {
    Stream stream = SpotifySdk.subscribePlayerState();
    stream.listen((playerState) {
      print('player: new state player!');
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
        emit(SpotifyPlayerNotConnected());
      }
    });
  }

  // void connectToSpotifyRemote() async {
  //   try {
  //     await spotifyRepository.connectToSpotifyRemote();
  //   } catch (e) {
  //     connectToSpotifyRemote();
  //   }
  // }

  // void listenConnectionStatus() async {
  //   connectToSpotifyRemote();
  //   Stream stream = SpotifySdk.subscribeConnectionStatus();
  //   stream.listen((connectionStatus) async {
  //     if (connectionStatus != null && connectionStatus is ConnectionStatus) {
  //       if (connectionStatus.connected) {
  //         listenToPlayerState();
  //         connected = true;
  //         emit(SpotifyPlayerConnected());
  //       } else {
  //         connected = false;
  //         emit(SpotifyPlayerNotConnected());
  //         connectToSpotifyRemote();
  //       }
  //     }
  //   });
  // }

  void errorPlayingTrack(String error) {
    emit(SpotifyPlayerError(error: error));
  }
}
