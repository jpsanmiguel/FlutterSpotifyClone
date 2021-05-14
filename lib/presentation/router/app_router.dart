import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/data/spotify_repository.dart';
import 'package:spotify_clone/presentation/screens/saved_tracks_page.dart';
import 'package:spotify_clone/presentation/screens/top_tracks_page.dart';

class AppRouter {
  final Repository repository;

  AppRouter({
    @required this.repository,
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
