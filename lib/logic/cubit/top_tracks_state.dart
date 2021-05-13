part of 'top_tracks_cubit.dart';

@immutable
abstract class TopTracksState {}

class TopTracksInitial extends TopTracksState {}

class TopTracksLoading extends TopTracksState {}

class TopTracksLoadingMore extends TopTracksState {
  final TopTracksPagingResponse topTracksPagingResponse;
  final bool hasReachedEnd;

  TopTracksLoadingMore(
      {@required this.hasReachedEnd, @required this.topTracksPagingResponse});
}

class TopTracksLoadedMore extends TopTracksState {
  final TopTracksPagingResponse topTracksPagingResponse;
  final bool hasReachedEnd;

  TopTracksLoadedMore(
      {@required this.hasReachedEnd, @required this.topTracksPagingResponse});

  TopTracksLoadedMore copyWith(
      {TopTracksPagingResponse topTracksPagingResponse, bool hasReachedEnd}) {
    return TopTracksLoadedMore(
      topTracksPagingResponse:
          topTracksPagingResponse ?? this.topTracksPagingResponse,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class TopTracksLoaded extends TopTracksState {
  final TopTracksPagingResponse savedTracksPagingResponse;

  TopTracksLoaded({@required this.savedTracksPagingResponse});
}
