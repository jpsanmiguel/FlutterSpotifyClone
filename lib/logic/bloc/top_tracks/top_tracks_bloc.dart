import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';

part 'top_tracks_event.dart';
part 'top_tracks_state.dart';

class TopTracksBloc extends Bloc<TopTracksEvent, TopTracksState> {
  final SpotifyRepository spotifyRepository;
  TopTracksBloc({
    @required this.spotifyRepository,
  }) : super(TopTracksState());

  @override
  Stream<TopTracksState> mapEventToState(
    TopTracksEvent event,
  ) async* {
    if (event is TopTracksConnectionChanged) {
      yield state.copyWith(
        connectionType: event.connectionType,
        status: event.connectionType == ConnectionType.None
            ? TracksStatus.Failure
            : state.status,
      );
    } else {
      if (event is TopTracksFetch &&
          state.connectionType != ConnectionType.None) {
        try {
          yield await _mapTopTracksFetchedToState(state);
        } catch (e) {
          yield state.copyWith(
            status: TracksStatus.Failure,
          );
        }
      } else if (event is TopTracksAddTrackToLibrary) {
        try {
          yield state.copyWith(
            isAddingTrackToLibrary: true,
          );
          final prevTopTracksPagingResponse =
              state.topTracksPagingResponse.copyWith();
          final actualTracks = <Track>[...prevTopTracksPagingResponse.tracks];
          event.track.inLibrary =
              await spotifyRepository.addToLibrary(event.track);
          prevTopTracksPagingResponse.tracks = actualTracks;
          yield state.copyWith(
            isAddingTrackToLibrary: false,
          );
        } on Exception {
          yield state.copyWith(isRemovingTrackFromLibrary: false);
        }
      } else if (event is TopTracksRemoveTrackFromLibrary) {
        try {
          yield state.copyWith(
            isRemovingTrackFromLibrary: true,
          );
          final prevTopTracksPagingResponse =
              state.topTracksPagingResponse.copyWith();
          final actualTracks = <Track>[...prevTopTracksPagingResponse.tracks];
          event.track.inLibrary =
              await spotifyRepository.removeFromLibrary(event.track);
          prevTopTracksPagingResponse.tracks = actualTracks;
          yield state.copyWith(
            isRemovingTrackFromLibrary: false,
          );
        } on Exception {
          yield state.copyWith(isRemovingTrackFromLibrary: false);
        }
      } else if (event is TopTracksReset &&
          state.connectionType != ConnectionType.None) {
        yield state.copyWith(
          hasReachedEnd: false,
          topTracksPagingResponse: TopTracksPagingResponse(),
          status: TracksStatus.Initial,
        );
        add(TopTracksFetch());
      } else if (event is TopTracksScrollTop) {
        yield state.copyWith(
          scrollToTop: true,
        );
        yield state.copyWith(
          scrollToTop: false,
        );
      }
    }
  }

  Future<TopTracksState> _mapTopTracksFetchedToState(
      TopTracksState state) async {
    if (state.hasReachedEnd) return state;
    try {
      if (state.status == TracksStatus.Initial) {
        final topTracksPagingResponse =
            await spotifyRepository.fetchUserTopTracks();
        return state.copyWith(
          status: TracksStatus.Success,
          topTracksPagingResponse: topTracksPagingResponse,
          hasReachedEnd: topTracksPagingResponse.next == null,
        );
      }
      final topTracksPagingResponse = await spotifyRepository
          .fetchMoreUserTopTracks(nextUrl: state.topTracksPagingResponse.next);
      if (topTracksPagingResponse.tracks.isEmpty) {
        return state.copyWith(
          hasReachedEnd: true,
        );
      } else {
        final allTopTracksPagingResponse = topTracksPagingResponse;
        final tracks = state.topTracksPagingResponse.tracks;
        tracks.addAll(topTracksPagingResponse.tracks);
        allTopTracksPagingResponse.tracks = tracks;
        return state.copyWith(
          status: TracksStatus.Success,
          topTracksPagingResponse: allTopTracksPagingResponse,
          hasReachedEnd: allTopTracksPagingResponse.next == null,
        );
      }
    } on Exception {
      return state.copyWith(
        status: TracksStatus.Failure,
      );
    }
  }

  Future<TopTracksState> addTrackToLibrary(
    TopTracksAddTrackToLibrary event,
    TopTracksState state,
  ) async {
    try {
      event.track.inLibrary = true;
      final prevTopTracksPagingResponse =
          state.topTracksPagingResponse.copyWith();
      event.track.inLibrary = await spotifyRepository.addToLibrary(event.track);
      return state.copyWith(
        isAddingTrackToLibrary: true,
        topTracksPagingResponse: prevTopTracksPagingResponse,
      );
    } on Exception {
      return state.copyWith(isAddingTrackToLibrary: false);
    }
  }
}
