import 'package:equatable/equatable.dart';

import 'package:spotify_clone/data/models/error.dart';
import 'package:spotify_clone/data/models/saved_track.dart';

class SavedTracksPagingResponse extends Equatable {
  List<SavedTrack> tracks;
  int total;
  int limit;
  int offset;
  String previous;
  String next;
  ErrorModel error;

  SavedTracksPagingResponse({
    this.tracks,
    this.total,
    this.limit,
    this.offset,
    this.previous,
    this.next,
    this.error,
  });

  SavedTracksPagingResponse.fromJson(Map<String, dynamic> json) {
    tracks = <SavedTrack>[];
    if (json['items'] != null && json['items'].toString().isNotEmpty) {
      json['items'].forEach((track) => tracks.add(SavedTrack.fromJson(track)));
    }
    if (json['error'] != null) {
      error = ErrorModel.fromJson(json['error']);
    }
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    previous = json['previous'];
    next = json['next'];
  }

  @override
  List<Object> get props =>
      [tracks, total, limit, offset, previous, next, error];

  SavedTracksPagingResponse copyWith({
    List<SavedTrack> tracks,
    int total,
    int limit,
    int offset,
    String previous,
    String next,
    ErrorModel error,
  }) {
    return SavedTracksPagingResponse(
      tracks: tracks ?? this.tracks,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      previous: previous ?? this.previous,
      next: next ?? this.next,
      error: error ?? this.error,
    );
  }
}
