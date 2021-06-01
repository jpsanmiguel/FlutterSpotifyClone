import 'package:spotify_sdk/models/artist.dart' as Spotify;

class Artist {
  String name;
  String uri;

  Artist({
    this.name,
    this.uri,
  });

  Artist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uri = json['uri'];
  }

  Artist.fromSpotifySdkArtist(Spotify.Artist artist) {
    name = artist.name;
    uri = artist.uri;
  }
}
