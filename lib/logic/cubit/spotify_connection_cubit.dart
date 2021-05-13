import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repository.dart';

part 'spotify_connection_state.dart';

class SpotifyPlayerCubit extends Cubit<SpotifyPlayerState> {
  final Repository repository;

  SpotifyPlayerCubit({@required this.repository})
      : super(SpotifyPlayerInitial());

  bool connected = false;

  void connectToSpotifyRemote() async {
    if (!connected) {
      emit(SpotifyPlayerConnecting());
      if (await repository.connectToSpotifyRemote()) {
        connected = true;
        emit(SpotifyPlayerConnected());
      } else {
        emit(SpotifyPlayerConnectionFailed());
      }
    }
  }

  void play(Track track) async {
    if (connected) {
      emit(SpotifyPlayerPlaying(track: track));
      await repository.play(track);
    } else {
      await connectToSpotifyRemote();
      play(track);
    }
  }

  void pause(Track track) async {
    if (connected) {
      emit(SpotifyPlayerPaused(track: track));
      await repository.pause();
    } else {
      await connectToSpotifyRemote();
      pause(track);
    }
  }

  void resume(Track track) async {
    if (connected) {
      emit(SpotifyPlayerPlaying(track: track));
      await repository.resume();
    } else {
      await connectToSpotifyRemote();
      resume(track);
    }
  }
}
