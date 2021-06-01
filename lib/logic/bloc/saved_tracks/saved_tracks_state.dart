part of 'saved_tracks_bloc.dart';

class SavedTracksState extends Equatable {
  final TracksStatus status;
  final SavedTracksPagingResponse savedTracksPagingResponse;
  final bool hasReachedEnd;
  final ConnectionType connectionType;
  final bool scrollToTop;

  SavedTracksState({
    this.status = TracksStatus.Initial,
    this.savedTracksPagingResponse,
    this.hasReachedEnd = false,
    this.connectionType,
    this.scrollToTop = false,
  });

  SavedTracksState copyWith({
    TracksStatus status,
    SavedTracksPagingResponse savedTracksPagingResponse,
    bool hasReachedEnd,
    ConnectionType connectionType,
    bool scrollToTop,
  }) {
    return SavedTracksState(
      status: status ?? this.status,
      savedTracksPagingResponse:
          savedTracksPagingResponse ?? this.savedTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      connectionType: connectionType ?? this.connectionType,
      scrollToTop: scrollToTop ?? false,
    );
  }

  @override
  List<Object> get props => [
        status,
        savedTracksPagingResponse,
        hasReachedEnd,
        connectionType,
        scrollToTop,
      ];
}
