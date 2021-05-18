import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/data/auth_repository.dart';
import 'package:spotify_clone/data/spotify_repository.dart';
import 'package:spotify_clone/presentation/screens/saved_tracks_page.dart';
import 'package:spotify_clone/presentation/screens/top_tracks_page.dart';

class BottomRouter {
  final SpotifyRepository spotifyRepository;
  final AuthRepository authRepository;

  BottomRouter({
    @required this.spotifyRepository,
    @required this.authRepository,
  }) : super();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => TopTracksPage(),
        );
      case '/saved':
        return MaterialPageRoute(
          builder: (_) => SavedTracksPage(),
        );
      default:
        return null;
    }
  }
}
