part of 'top_tracks_bloc.dart';

class TopTracksState {
  final TracksStatus status;
  final TopTracksPagingResponse topTracksPagingResponse;
  final bool hasReachedEnd;
  final ConnectionType connectionType;
  final bool scrollToTop;

  TopTracksState({
    this.status = TracksStatus.Initial,
    this.topTracksPagingResponse,
    this.hasReachedEnd = false,
    this.connectionType,
    this.scrollToTop,
  });

  TopTracksState copyWith({
    TracksStatus status,
    TopTracksPagingResponse topTracksPagingResponse,
    bool hasReachedEnd,
    ConnectionType connectionType,
    bool scrollToTop,
  }) {
    return TopTracksState(
      status: status ?? this.status,
      topTracksPagingResponse:
          topTracksPagingResponse ?? this.topTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      connectionType: connectionType ?? this.connectionType,
      scrollToTop: scrollToTop ?? false,
    );
  }
}
