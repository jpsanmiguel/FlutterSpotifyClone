part of 'saved_tracks_cubit.dart';

@immutable
abstract class SavedTracksState {}

class SavedTracksInitial extends SavedTracksState {}

class SavedTracksLoading extends SavedTracksState {}

class SavedTracksLoaded extends SavedTracksState {
  final SavedTracksPagingResponse savedTracksPagingResponse;

  SavedTracksLoaded({@required this.savedTracksPagingResponse});
}
