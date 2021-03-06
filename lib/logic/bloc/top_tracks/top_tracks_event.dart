part of 'top_tracks_bloc.dart';

@immutable
abstract class TopTracksEvent {}

class TopTracksFetch extends TopTracksEvent {}

class TopTracksAddTrackToLibrary extends TopTracksEvent {
  final Track track;

  TopTracksAddTrackToLibrary({@required this.track});
}

class TopTracksRemoveTrackFromLibrary extends TopTracksEvent {
  final Track track;

  TopTracksRemoveTrackFromLibrary({@required this.track});
}

class TopTracksReset extends TopTracksEvent {}

class TopTracksConnectionChanged extends TopTracksEvent {
  final ConnectionType connectionType;

  TopTracksConnectionChanged({@required this.connectionType});
}

class TopTracksScrollTop extends TopTracksEvent {}
