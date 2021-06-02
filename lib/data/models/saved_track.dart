import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:spotify_clone/data/models/track.dart';

class SavedTrack extends Equatable {
  String addedAt;
  Track track;

  SavedTrack({this.addedAt, this.track});

  factory SavedTrack.fromJson(Map<String, dynamic> json) {
    Track track;
    if (json['track'] != null) {
      track = Track.fromJson(json['track']);
      track.inLibrary = true;
    }
    return SavedTrack(addedAt: json['added_at'], track: track);
  }

  @override
  List<Object> get props => [addedAt, track];
}
