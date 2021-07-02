part of 'top_tracks_bloc.dart';

class TopTracksState extends Equatable {
  final TracksStatus status;
  final TopTracksPagingResponse topTracksPagingResponse;
  final bool hasReachedEnd;
  final ConnectionType connectionType;
  final bool scrollToTop;
  final bool isAddingTrackToLibrary;
  final bool isRemovingTrackFromLibrary;

  TopTracksState({
    this.status = TracksStatus.Initial,
    this.topTracksPagingResponse,
    this.hasReachedEnd = false,
    this.connectionType,
    this.scrollToTop = false,
    this.isAddingTrackToLibrary,
    this.isRemovingTrackFromLibrary,
  });

  TopTracksState copyWith({
    TracksStatus status,
    TopTracksPagingResponse topTracksPagingResponse,
    bool hasReachedEnd,
    ConnectionType connectionType,
    bool scrollToTop,
    bool isAddingTrackToLibrary,
    bool isRemovingTrackFromLibrary,
  }) {
    return TopTracksState(
      status: status ?? this.status,
      topTracksPagingResponse:
          topTracksPagingResponse ?? this.topTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      connectionType: connectionType ?? this.connectionType,
      scrollToTop: scrollToTop ?? false,
      isAddingTrackToLibrary: isAddingTrackToLibrary,
      isRemovingTrackFromLibrary: isRemovingTrackFromLibrary,
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
      isAddingTrackToLibrary,
      isRemovingTrackFromLibrary,
    ];
  }
}
