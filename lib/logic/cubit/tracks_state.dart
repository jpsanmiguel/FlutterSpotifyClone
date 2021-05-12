part of 'tracks_cubit.dart';

@immutable
abstract class TracksState {}

class TracksInitial extends TracksState {}

class TracksLoading extends TracksState {}

class TracksLoaded extends TracksState {
  final TracksPagingResponse tracksPagingResponse;

  TracksLoaded({@required this.tracksPagingResponse});
}
