part of 'saved_tracks_bloc.dart';

class SavedTracksState {
  final TracksStatus status;
  final SavedTracksPagingResponse savedTracksPagingResponse;
  final bool hasReachedEnd;

  SavedTracksState({
    this.status = TracksStatus.Initial,
    this.savedTracksPagingResponse,
    this.hasReachedEnd = false,
  });

  SavedTracksState copyWith({
    TracksStatus status,
    SavedTracksPagingResponse savedTracksPagingResponse,
    bool hasReachedEnd,
  }) {
    return SavedTracksState(
      status: status ?? this.status,
      savedTracksPagingResponse:
          savedTracksPagingResponse ?? this.savedTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}
