import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/data/repository.dart';
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
      default:
        return null;
    }
  }
}
