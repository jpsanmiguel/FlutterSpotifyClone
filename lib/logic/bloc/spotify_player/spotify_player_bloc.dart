import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

part 'spotify_player_event.dart';
part 'spotify_player_state.dart';

class SpotifyPlayerBloc extends Bloc<SpotifyPlayerEvent, SpotifyPlayerState> {
  final SpotifyRepository spotifyRepository;
  SpotifyPlayerBloc({
    @required this.spotifyRepository,
  }) : super(SpotifyPlayerState());

  PlayerState actualPlayerState;
  Track actualTrack;

  @override
  Stream<SpotifyPlayerState> mapEventToState(
    SpotifyPlayerEvent event,
  ) async* {
    if (event is SpotifyPlayerConnect) {
      yield state.copyWith(
        connectionStatus: SpotifyPlayerConnectionStatus.Connecting,
      );
      final connected = await spotifyRepository.connectToSpotifyRemote();
      if (connected) listenToPlayerState();
      yield state.copyWith(
        connectionStatus: connected
            ? SpotifyPlayerConnectionStatus.Connected
            : SpotifyPlayerConnectionStatus.Disconnected,
      );
    } else if (event is SpotifyPlayerConnected) {
      yield state.copyWith(
        track: actualTrack ?? event.track,
        reproductionStatus: event.reproductionStatus,
      );
    } else if (event is SpotifyPlayerPlay) {
      try {
        await _play(event.track);
      } on PlatformException {
        yield state.copyWith(
          connectionStatus: SpotifyPlayerConnectionStatus.Disconnected,
        );
      }
    } else if (event is SpotifyPlayerPause) {
      try {
        await spotifyRepository.pause();
      } on PlatformException {
        yield state.copyWith(
          connectionStatus: SpotifyPlayerConnectionStatus.Disconnected,
        );
      }
    } else if (event is SpotifyPlayerResume) {
      try {
        await spotifyRepository.resume();
      } on PlatformException {
        yield state.copyWith(
          connectionStatus: SpotifyPlayerConnectionStatus.Disconnected,
        );
      }
      yield state.copyWith(
        reproductionStatus: SpotifyPlayerReproductionStatus.Playing,
      );
    } else if (event is SpotifyPlayerLoading) {
      yield state.copyWith(
        reproductionStatus: SpotifyPlayerReproductionStatus.Loading,
      );
    } else if (event is SpotifyPlayerError) {
      yield state.copyWith(
        error: event.error,
      );
    } else {
      if (state.connectionStatus == SpotifyPlayerConnectionStatus.Connected) {
        yield state.copyWith(
          reproductionStatus: SpotifyPlayerReproductionStatus.Loading,
        );
      } else {
        yield state.copyWith(
          connectionStatus: SpotifyPlayerConnectionStatus.Disconnected,
        );
      }
    }
  }

  Future _play(Track track) async {
    actualTrack = track;
    var beforePlayerState = actualPlayerState;
    await spotifyRepository.play(track);
    if (beforePlayerState.track == null && actualPlayerState.track == null) {
      add(SpotifyPlayerError(error: 'Error reproduciendo la canción'));
    }
    Future.delayed(Duration(seconds: 5), () {
      if (actualPlayerState.track == null && actualTrack.id == track.id) {
        add(SpotifyPlayerError(error: 'Error reproduciendo la canción'));
      }
    });
  }

  void listenToPlayerState() async {
    Stream stream = SpotifySdk.subscribePlayerState();
    stream.listen((playerState) {
      actualPlayerState = playerState;
      if (playerState != null && playerState is PlayerState) {
        if (playerState.track != null) {
          if (playerState.isPaused) {
            add(
              SpotifyPlayerConnected(
                track: Track.fromSpotifySdkTrack(playerState.track),
                reproductionStatus: SpotifyPlayerReproductionStatus.Paused,
              ),
            );
          } else {
            add(
              SpotifyPlayerConnected(
                track: Track.fromSpotifySdkTrack(playerState.track),
                reproductionStatus: SpotifyPlayerReproductionStatus.Playing,
              ),
            );
          }
        } else {
          add(SpotifyPlayerLoading());
        }
      } else {
        add(SpotifyPlayerConnect());
      }
    });
  }
}
