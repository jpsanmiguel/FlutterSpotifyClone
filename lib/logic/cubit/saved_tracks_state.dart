part of 'saved_tracks_cubit.dart';

@immutable
abstract class SavedTracksState {}

class SavedTracksInitial extends SavedTracksState {}

class SavedTracksLoading extends SavedTracksState {}

class SavedTracksLoadingMore extends SavedTracksState {
  final SavedTracksPagingResponse savedTracksPagingResponse;
  final bool hasReachedEnd;

  SavedTracksLoadingMore({
    @required this.hasReachedEnd,
    @required this.savedTracksPagingResponse,
  });
}

class SavedTracksLoadedMore extends SavedTracksState {
  final SavedTracksPagingResponse savedTracksPagingResponse;
  final bool hasReachedEnd;

  SavedTracksLoadedMore({
    @required this.hasReachedEnd,
    @required this.savedTracksPagingResponse,
  });
}

class SavedTracksLoaded extends SavedTracksState {
  final SavedTracksPagingResponse savedTracksPagingResponse;

  SavedTracksLoaded({@required this.savedTracksPagingResponse});
}
