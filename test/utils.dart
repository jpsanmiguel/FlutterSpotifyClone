import 'dart:math';

import 'package:random_string/random_string.dart';
import 'package:spotify_clone/data/models/album_simplified.dart';
import 'package:spotify_clone/data/models/artist.dart';
import 'package:spotify_clone/data/models/image.dart';
import 'package:spotify_clone/data/models/saved_track.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';

SavedTracksPagingResponse randomSavedTracksPagingResponseWithNTracks({
  int size,
  bool isInitial,
  bool isFinal,
  bool tracksInLibrary,
}) {
  return SavedTracksPagingResponse(
    limit: randomInt(50),
    next: isFinal ? null : randomAlphaNumeric(30),
    offset: randomInt(50),
    previous: isInitial ? null : randomAlphaNumeric(30),
    total: size,
    tracks: randomSavedTracks(size: size, tracksInLibrary: tracksInLibrary),
  );
}

List<SavedTrack> randomSavedTracks({int size, bool tracksInLibrary}) {
  List<SavedTrack> savedTracks = [];
  for (var i = 0; i < size; i++) {
    savedTracks.add(randomSavedTrack(tracksInLibrary: tracksInLibrary));
  }
  return savedTracks;
}

SavedTrack randomSavedTrack({bool tracksInLibrary}) {
  return SavedTrack(
    addedAt: randomAlphaNumeric(10),
    track: randomTrack(tracksInLibrary: tracksInLibrary),
  );
}

Track randomTrack({bool tracksInLibrary}) {
  return Track(
    album: randomAlbumSimplified(),
    artists: randomArtists(),
    id: randomString(6),
    name: randomString(10),
    uri: randomString(30),
    inLibrary: tracksInLibrary,
  );
}

AlbumSimplified randomAlbumSimplified() {
  return AlbumSimplified(
    images: randomImages(),
    name: randomString(10),
    releaseDate: randomAlphaNumeric(10),
    totalTracks: randomInt(15),
    uri: randomAlphaNumeric(30),
  );
}

List<Image> randomImages() {
  int size = randomInt(3);
  List<Image> images = [];
  for (var i = 0; i < size; i++) {
    images.add(randomImage());
  }
  return images;
}

Image randomImage() {
  return Image(
    height: randomInt(100),
    url: randomAlphaNumeric(30),
    width: randomInt(100),
  );
}

List<Artist> randomArtists() {
  int size = randomInt(5);
  List<Artist> artists = [];
  for (var i = 0; i < size; i++) {
    artists.add(randomArtist());
  }
  return artists;
}

Artist randomArtist() {
  return Artist(
    name: randomString(10),
    uri: randomAlphaNumeric(30),
  );
}

int randomInt(int max) {
  return Random().nextInt(max);
}
