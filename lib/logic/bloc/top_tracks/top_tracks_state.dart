part of 'top_tracks_bloc.dart';

class TopTracksState extends Equatable {
  final TracksStatus status;
  final TopTracksPagingResponse topTracksPagingResponse;
  final bool hasReachedEnd;
  final ConnectionType connectionType;
  final bool scrollToTop;
  final bool addedTrackToLibrary;
  final bool removedTrackFromLibrary;

  TopTracksState({
    this.status = TracksStatus.Initial,
    this.topTracksPagingResponse,
    this.hasReachedEnd = false,
    this.connectionType,
    this.scrollToTop = false,
    this.addedTrackToLibrary,
    this.removedTrackFromLibrary,
  });

  TopTracksState copyWith({
    TracksStatus status,
    TopTracksPagingResponse topTracksPagingResponse,
    bool hasReachedEnd,
    ConnectionType connectionType,
    bool scrollToTop,
    bool addedTrackToLibrary,
    bool removedTrackFromLibrary,
  }) {
    return TopTracksState(
      status: status ?? this.status,
      topTracksPagingResponse:
          topTracksPagingResponse ?? this.topTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      connectionType: connectionType ?? this.connectionType,
      scrollToTop: scrollToTop ?? false,
      addedTrackToLibrary: addedTrackToLibrary,
      removedTrackFromLibrary: removedTrackFromLibrary,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      topTracksPagingResponse,
      hasReachedEnd,
      connectionType,
      scrollToTop,
      addedTrackToLibrary,
      removedTrackFromLibrary,
    ];
  }
}
