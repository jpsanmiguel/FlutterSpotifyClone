import 'package:equatable/equatable.dart';

import 'package:spotify_clone/data/models/error.dart';
import 'package:spotify_clone/data/models/track.dart';

class TopTracksPagingResponse extends Equatable {
  List<Track> tracks;
  int total;
  int limit;
  int offset;
  String previous;
  String next;
  ErrorModel error;

  TopTracksPagingResponse({
    this.tracks,
    this.total,
    this.limit,
    this.offset,
    this.previous,
    this.next,
    this.error,
  });

  TopTracksPagingResponse.fromJson(Map<String, dynamic> json) {
    tracks = <Track>[];
    if (json['items'] != null && json['items'].toString().isNotEmpty) {
      json['items'].forEach((track) => tracks.add(Track.fromJson(track)));
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

  TopTracksPagingResponse copyWith({
    List<Track> tracks,
    int total,
    int limit,
    int offset,
    String previous,
    String next,
    ErrorModel error,
  }) {
    return TopTracksPagingResponse(
      tracks: tracks ?? this.tracks,
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      previous: previous ?? this.previous,
      next: next ?? this.next,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props {
    return [
      tracks,
      total,
      limit,
      offset,
      previous,
      next,
      error,
    ];
  }
}
