part of 'saved_tracks_bloc.dart';

@immutable
abstract class SavedTracksEvent {}

class SavedTracksFetch extends SavedTracksEvent {}

class SavedTracksAddTrackToLibrary extends SavedTracksEvent {
  final Track track;

  SavedTracksAddTrackToLibrary({@required this.track});
}

class SavedTracksRemoveTrackToLibrary extends SavedTracksEvent {
  final Track track;

  SavedTracksRemoveTrackToLibrary({@required this.track});
}

class SavedTracksReset extends SavedTracksEvent {}

class SavedTracksConnectionChanged extends SavedTracksEvent {
  final ConnectionType connectionType;

  SavedTracksConnectionChanged({@required this.connectionType});
}

class SavedTracksScrollTop extends SavedTracksEvent {}
