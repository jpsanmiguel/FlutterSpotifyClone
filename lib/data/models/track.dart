import 'dart:core';

import 'package:spotify_clone/data/models/album_simplified.dart';
import 'package:spotify_clone/data/models/artist.dart';

class Track {
  AlbumSimplified album;
  List<Artist> artists;
  String id;
  bool isPlayable;
  String name;
  String uri;

  Track({this.artists, this.id, this.isPlayable, this.name, this.uri});

  Track.fromJson(Map<String, dynamic> json) {
    if (json['album'] != null) {
      album = AlbumSimplified.fromJson(json['album']);
    }
    artists = <Artist>[];
    if (json['artists'] != null && json['artists'].toString().isNotEmpty) {
      json['artists'].forEach((artist) => artists.add(Artist.fromJson(artist)));
    }
    id = json['id'];
    isPlayable = json['is_playable'];
    name = json['name'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();

    if (artists != null) {
      json['artists'] = artists.map((artist) => artist.toJson()).toList();
    }
    json['id'] = id;
    json['is_playable'] = isPlayable;
    json['name'] = name;
    json['uri'] = uri;

    return json;
  }
}
