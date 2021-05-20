import 'dart:async';

import 'package:bloc/bloc.dart';
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
      if (event is TopTracksFetched) {
        try {
          if (state.connectionType != ConnectionType.None) {
            yield await _mapTopTracksFetchedToState(state);
          }
        } catch (e) {
          yield state.copyWith(status: TracksStatus.Failure);
        }
      } else if (event is TopTracksAddTrackToLibrary) {
        event.track.inLibrary =
            await spotifyRepository.addToLibrary(event.track);
        yield state.copyWith();
      } else if (event is TopTracksRemoveTrackToLibrary) {
        event.track.inLibrary =
            await spotifyRepository.removeFromLibrary(event.track);
        yield state.copyWith();
      } else if (event is TopTracksReset) {
        if (state.connectionType != ConnectionType.None) {
          yield state.copyWith(
            hasReachedEnd: false,
            topTracksPagingResponse: null,
            status: TracksStatus.Initial,
          );
          add(TopTracksFetched());
        }
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
          hasReachedEnd: topTracksPagingResponse.total ==
              topTracksPagingResponse.tracks.length,
        );
      }
      final topTracksPagingResponse = await spotifyRepository
          .fetchUserTopTracks(nextUrl: state.topTracksPagingResponse.next);
      if (topTracksPagingResponse.tracks.isEmpty) {
        return state.copyWith(hasReachedEnd: true);
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
      return state.copyWith(status: TracksStatus.Failure);
    }
  }
}
