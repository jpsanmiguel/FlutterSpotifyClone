import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/models/User.dart';
import 'package:spotify_clone/presentation/screens/saved_tracks_page.dart';
import 'package:spotify_clone/presentation/screens/top_tracks_page.dart';

class BottomRouter {
  final SpotifyRepository spotifyRepository;
  final AuthRepository authRepository;
  final User user;

  BottomRouter({
    @required this.spotifyRepository,
    @required this.authRepository,
    @required this.user,
  }) : super();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => TopTracksPage(
            user: user,
          ),
        );
      case '/saved':
        return MaterialPageRoute(
          builder: (_) => SavedTracksPage(
            user: user,
          ),
        );
      default:
        return null;
    }
  }
}
