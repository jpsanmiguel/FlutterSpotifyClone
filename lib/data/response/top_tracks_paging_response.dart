import 'package:spotify_clone/data/models/error.dart';
import 'package:spotify_clone/data/models/track.dart';

class TopTracksPagingResponse {
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
}
