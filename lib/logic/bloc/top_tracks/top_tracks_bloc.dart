import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';
import 'package:rxdart/rxdart.dart';

part 'top_tracks_event.dart';
part 'top_tracks_state.dart';

class TopTracksBloc extends Bloc<TopTracksEvent, TopTracksState> {
  final SpotifyRepository spotifyRepository;
  TopTracksBloc({
    @required this.spotifyRepository,
  }) : super(TopTracksState());

  @override
  Stream<Transition<TopTracksEvent, TopTracksState>> transformEvents(
      Stream<TopTracksEvent> events, transitionFn) {
    return super.transformEvents(
      events.debounceTime(Duration(seconds: 1)),
      transitionFn,
    );
  }

  @override
  Stream<TopTracksState> mapEventToState(
    TopTracksEvent event,
  ) async* {
    if (event is TopTracksFetched) {
      print('called top tracks fetched!');
      yield await _mapTopTracksFetchedToState(state);
    } else if (event is TopTracksAddTrackToLibrary) {
      await spotifyRepository.addToLibrary(event.track);
      event.track.inLibrary = true;
      yield state.copyWith();
    } else if (event is TopTracksRemoveTrackToLibrary) {
      await spotifyRepository.removeFromLibrary(event.track);
      event.track.inLibrary = false;
      yield state.copyWith();
    } else if (event is TopTracksReset) {
      yield state.copyWith(
        hasReachedEnd: false,
        topTracksPagingResponse: null,
        status: TracksStatus.Initial,
      );
      add(TopTracksFetched());
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
          .fetchUserTopTracks(nextUrl: state.topTracksPagingResponse.next);
      if (topTracksPagingResponse.tracks.isEmpty) {
        return state.copyWith(hasReachedEnd: true);
      } else {
        final allTopTracksPagingResponse = topTracksPagingResponse;
        final tracks = state.topTracksPagingResponse.tracks;
        tracks.addAll(topTracksPagingResponse.tracks);
        allTopTracksPagingResponse.tracks = tracks;

        print('prevNext: ${state.topTracksPagingResponse.next}');
        print('follNext: ${topTracksPagingResponse.next}');
        print('finalNext: ${allTopTracksPagingResponse.next}');

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
