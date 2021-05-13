import 'package:spotify_clone/data/models/image.dart';
import 'package:spotify_sdk/models/album.dart' as Spotify;

class AlbumSimplified {
  List<Image> images;
  String name;
  String releaseDate;
  int totalTracks;
  String uri;

  AlbumSimplified({
    this.images,
    this.name,
    this.releaseDate,
    this.totalTracks,
    this.uri,
  });

  AlbumSimplified.fromJson(Map<String, dynamic> json) {
    images = <Image>[];
    if (json['images'] != null && json['images'].toString().isNotEmpty) {
      json['images'].forEach((image) => images.add(Image.fromJson(image)));
    }
    name = json['name'];
    releaseDate = json['release_date'];
    totalTracks = json['total_tracks'];
    uri = json['uri'];
  }

  AlbumSimplified.fromSpotifySdkAlbum(Spotify.Album album, String url) {
    name = album.name;
    uri = album.uri;
    images = [Image(url: url)];
  }
}
