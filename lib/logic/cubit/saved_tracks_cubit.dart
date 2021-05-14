import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/saved_track.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/spotify_repository.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';

part 'saved_tracks_state.dart';

class SavedTracksCubit extends Cubit<SavedTracksState> {
  final Repository repository;

  SavedTracksCubit({@required this.repository}) : super(SavedTracksInitial());

  String nextUrl;
  bool hasReachedEnd = false;
  List<SavedTrack> tracks = [];
  SavedTracksPagingResponse savedTracksPagingResponse;

  void fetchUserSavedTracks() async {
    if (!(state is SavedTracksLoadingMore)) {
      if (!hasReachedEnd) {
        if (tracks.isEmpty) {
          emit(SavedTracksLoading());
        } else {
          emit(SavedTracksLoadingMore(
              hasReachedEnd: hasReachedEnd,
              savedTracksPagingResponse: savedTracksPagingResponse));
        }
        print('call to fetch');
        savedTracksPagingResponse =
            await repository.fetchUserSavedTracks(nextUrl);
        nextUrl = savedTracksPagingResponse.next;
        if (savedTracksPagingResponse.next == null) {
          hasReachedEnd = true;
        }
        tracks = tracks + savedTracksPagingResponse.tracks;

        final fullTracksPagingResponse = savedTracksPagingResponse;
        fullTracksPagingResponse.tracks = tracks;
        emit(SavedTracksLoadedMore(
            savedTracksPagingResponse: fullTracksPagingResponse,
            hasReachedEnd: hasReachedEnd));
      }
    }
  }

  Future removeFromLibrary(Track track) async {
    await repository.removeFromLibrary(track);
    track.inLibrary = false;
    if (state is SavedTracksLoaded) {
      emit(SavedTracksLoaded(
          savedTracksPagingResponse: savedTracksPagingResponse));
    }
    if (state is SavedTracksLoadedMore) {
      emit(SavedTracksLoadedMore(
          savedTracksPagingResponse: savedTracksPagingResponse,
          hasReachedEnd: hasReachedEnd));
    }
  }

  Future addToLibrary(Track track) async {
    await repository.addToLibrary(track);
    track.inLibrary = true;
    if (state is SavedTracksLoaded) {
      emit(SavedTracksLoaded(
          savedTracksPagingResponse: savedTracksPagingResponse));
    }
    if (state is SavedTracksLoadedMore) {
      emit(SavedTracksLoadedMore(
          savedTracksPagingResponse: savedTracksPagingResponse,
          hasReachedEnd: hasReachedEnd));
    }
  }

  void resetSavedTracks() async {
    emit(SavedTracksInitial());
    nextUrl = null;
    hasReachedEnd = false;
    tracks = [];
    savedTracksPagingResponse = null;
    fetchUserSavedTracks();
  }
}
