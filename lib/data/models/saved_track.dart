import 'dart:core';

import 'package:spotify_clone/data/models/track.dart';

class SavedTrack {
  String addedAt;
  Track track;

  SavedTrack({this.addedAt, this.track});

  SavedTrack.fromJson(Map<String, dynamic> json) {
    addedAt = json['added_at'];
    if (json['track'] != null) {
      track = Track.fromJson(json['track']);
    }
  }
}
