import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:spotify_clone/data/models/album_simplified.dart';
import 'package:spotify_clone/data/models/artist.dart';
import 'package:spotify_clone/utils/functions.dart';
import 'package:spotify_sdk/models/track.dart' as Spotify;

class Track extends Equatable {
  String id;
  AlbumSimplified album;
  List<Artist> artists;
  String name;
  String uri;
  bool inLibrary = false;

  Track(
      {this.id, this.album, this.artists, this.name, this.uri, this.inLibrary});

  factory Track.fromJson(Map<String, dynamic> json) {
    AlbumSimplified album;
    List<Artist> artists = <Artist>[];
    if (json['album'] != null) {
      album = AlbumSimplified.fromJson(json['album']);
    }
    if (json['artists'] != null && json['artists'].toString().isNotEmpty) {
      json['artists'].forEach((artist) => artists.add(Artist.fromJson(artist)));
    }
    return Track(
      id: json['id'],
      album: album,
      artists: artists,
      name: json['name'],
      uri: json['uri'],
      inLibrary: false,
    );
  }

  String getImageUrl() {
    if (album != null) {
      return album.images[0].url;
    }
    return '';
  }

  String getArtistsNames() {
    if (artists != null) {
      return artists.map((artist) => artist.name).join(", ");
    }
    return '';
  }

  Track.fromSpotifySdkTrack(Spotify.Track track) {
    var uriParts = track.uri.split(':');
    id = uriParts[uriParts.length - 1];
    album = AlbumSimplified.fromSpotifySdkAlbum(
        track.album, getImageUrlFromUri(track.imageUri.raw));
    artists = <Artist>[];
    track.artists
        .forEach((artist) => artists.add(Artist.fromSpotifySdkArtist(artist)));
    name = track.name;
    uri = track.uri;
  }

  @override
  List<Object> get props => [id, album, artists, name, uri, inLibrary];
}
