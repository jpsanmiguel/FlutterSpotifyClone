import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';

part 'saved_tracks_event.dart';
part 'saved_tracks_state.dart';

class SavedTracksBloc extends Bloc<SavedTracksEvent, SavedTracksState> {
  final SpotifyRepository spotifyRepository;
  SavedTracksBloc({
    @required this.spotifyRepository,
  }) : super(SavedTracksState());

  @override
  Stream<SavedTracksState> mapEventToState(
    SavedTracksEvent event,
  ) async* {
    if (event is SavedTracksConnectionChanged) {
      yield state.copyWith(
        connectionType: event.connectionType,
        status: event.connectionType == ConnectionType.None
            ? TracksStatus.Failure
            : state.status,
      );
    } else {
      if (event is SavedTracksFetched &&
          state.connectionType != ConnectionType.None) {
        try {
          yield await _mapSavedTracksFetchedToState(state);
        } catch (e) {
          yield state.copyWith(status: TracksStatus.Failure);
        }
      } else if (event is SavedTracksAddTrackToLibrary) {
        event.track.inLibrary = true;
        yield state.copyWith();
        event.track.inLibrary =
            await spotifyRepository.addToLibrary(event.track);
        yield state.copyWith();
      } else if (event is SavedTracksRemoveTrackToLibrary) {
        event.track.inLibrary = false;
        yield state.copyWith();
        event.track.inLibrary =
            await spotifyRepository.removeFromLibrary(event.track);
        yield state.copyWith();
      } else if (event is SavedTracksReset &&
          state.connectionType != ConnectionType.None) {
        yield state.copyWith(
          hasReachedEnd: false,
          savedTracksPagingResponse: null,
          status: TracksStatus.Initial,
        );
        add(SavedTracksFetched());
      }
    }
  }

  Future<SavedTracksState> _mapSavedTracksFetchedToState(
      SavedTracksState state) async {
    if (state.hasReachedEnd) return state;
    try {
      if (state.status == TracksStatus.Initial) {
        final savedTracksPagingResponse =
            await spotifyRepository.fetchUserSavedTracks();
        return state.copyWith(
          status: TracksStatus.Success,
          savedTracksPagingResponse: savedTracksPagingResponse,
          hasReachedEnd: savedTracksPagingResponse.next == null,
        );
      }
      final savedTracksPagingResponse = await spotifyRepository
          .fetchUserSavedTracks(nextUrl: state.savedTracksPagingResponse.next);
      if (savedTracksPagingResponse.tracks.isEmpty) {
        return state.copyWith(hasReachedEnd: true);
      } else {
        final allSavedTracksPagingResponse = savedTracksPagingResponse;
        final tracks = state.savedTracksPagingResponse.tracks;
        tracks.addAll(savedTracksPagingResponse.tracks);
        allSavedTracksPagingResponse.tracks = tracks;

        print('prevNext: ${state.savedTracksPagingResponse.next}');
        print('follNext: ${savedTracksPagingResponse.next}');
        print('finalNext: ${allSavedTracksPagingResponse.next}');

        return state.copyWith(
          status: TracksStatus.Success,
          savedTracksPagingResponse: allSavedTracksPagingResponse,
          hasReachedEnd: allSavedTracksPagingResponse.next == null,
        );
      }
    } on Exception {
      return state.copyWith(status: TracksStatus.Failure);
    }
  }
}
