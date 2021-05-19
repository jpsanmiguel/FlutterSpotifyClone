part of 'top_tracks_bloc.dart';

class TopTracksState {
  final TracksStatus status;
  final TopTracksPagingResponse topTracksPagingResponse;
  final bool hasReachedEnd;

  TopTracksState({
    this.status = TracksStatus.Initial,
    this.topTracksPagingResponse,
    this.hasReachedEnd = false,
  });

  TopTracksState copyWith({
    TracksStatus status,
    TopTracksPagingResponse topTracksPagingResponse,
    bool hasReachedEnd,
  }) {
    return TopTracksState(
      status: status ?? this.status,
      topTracksPagingResponse:
          topTracksPagingResponse ?? this.topTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}
