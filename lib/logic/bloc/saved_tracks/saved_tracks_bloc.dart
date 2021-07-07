import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/saved_track.dart';
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
      if (event is SavedTracksFetch &&
          state.connectionType != ConnectionType.None) {
        try {
          yield await _mapSavedTracksFetchedToState(state);
        } catch (e) {
          yield state.copyWith(
            status: TracksStatus.Failure,
          );
        }
      } else if (event is SavedTracksAddTrackToLibrary) {
        try {
          yield await addTrackToLibrary(event, state);
        } on Exception {
          yield state.copyWith(addedTrackToLibrary: false);
        }
      } else if (event is SavedTracksRemoveTrackFromLibrary) {
        yield await removeTrackFromLibrary(event, state);
      } else if (event is SavedTracksReset &&
          state.connectionType != ConnectionType.None) {
        yield state.copyWith(
          hasReachedEnd: false,
          savedTracksPagingResponse: SavedTracksPagingResponse(),
          status: TracksStatus.Initial,
        );
        add(SavedTracksFetch());
      } else if (event is SavedTracksScrollTop) {
        yield state.copyWith(
          scrollToTop: true,
        );
        yield state.copyWith(
          scrollToTop: false,
        );
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
      final savedTracksPagingResponse =
          await spotifyRepository.fetchMoreUserSavedTracks(
              nextUrl: state.savedTracksPagingResponse.next);
      if (savedTracksPagingResponse.tracks.isEmpty) {
        return state.copyWith(
          hasReachedEnd: true,
        );
      } else {
        final allSavedTracksPagingResponse = savedTracksPagingResponse;
        final tracks = state.savedTracksPagingResponse.tracks;
        tracks.addAll(savedTracksPagingResponse.tracks);
        allSavedTracksPagingResponse.tracks = tracks;

        return state.copyWith(
          status: TracksStatus.Success,
          savedTracksPagingResponse: allSavedTracksPagingResponse,
          hasReachedEnd: allSavedTracksPagingResponse.next == null,
        );
      }
    } on Exception {
      return state.copyWith(
        status: TracksStatus.Failure,
      );
    }
  }

  Future<SavedTracksState> addTrackToLibrary(
    SavedTracksAddTrackToLibrary event,
    SavedTracksState state,
  ) async {
    try {
      event.track.inLibrary = true;
      final prevSavedTracksPagingResponse =
          state.savedTracksPagingResponse.copyWith();
      event.track.inLibrary = await spotifyRepository.addToLibrary(event.track);
      return state.copyWith(
        addedTrackToLibrary: true,
        savedTracksPagingResponse: prevSavedTracksPagingResponse,
      );
    } on Exception {
      return state.copyWith(addedTrackToLibrary: false);
    }
  }

  Future<SavedTracksState> removeTrackFromLibrary(
    SavedTracksRemoveTrackFromLibrary event,
    SavedTracksState state,
  ) async {
    try {
      event.track.inLibrary = false;
      final prevSavedTracksPagingResponse =
          state.savedTracksPagingResponse.copyWith();
      final actualTracks = <SavedTrack>[
        ...prevSavedTracksPagingResponse.tracks
      ];
      actualTracks.removeWhere((element) => element.track.id == event.track.id);
      event.track.inLibrary =
          await spotifyRepository.removeFromLibrary(event.track);
      prevSavedTracksPagingResponse.tracks = actualTracks;
      return state.copyWith(
        removedTrackFromLibrary: true,
        savedTracksPagingResponse: prevSavedTracksPagingResponse,
      );
    } on Exception {
      return state.copyWith(removedTrackFromLibrary: false);
    }
  }
}
