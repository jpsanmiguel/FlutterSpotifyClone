part of 'top_tracks_cubit.dart';

@immutable
abstract class TopTracksState {}

class TopTracksInitial extends TopTracksState {}

class TopTracksLoading extends TopTracksState {}

class TopTracksLoaded extends TopTracksState {
  final TopTracksPagingResponse topTracksPagingResponse;

  TopTracksLoaded({@required this.topTracksPagingResponse});
}
