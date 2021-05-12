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

  String getImageUrl() {
    return album.images[0].url;
  }

  String getArtistsNames() {
    return artists.map((artist) => artist.name).join(", ");
  }
}
