import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/presentation/navigation/router/bottom_router.dart';
import 'package:spotify_clone/presentation/screens/home_page.dart';
import 'package:spotify_clone/presentation/screens/login_page.dart';
import 'package:spotify_clone/presentation/screens/register_page.dart';

class AppRouter {
  final SpotifyRepository spotifyRepository;
  final AuthRepository authRepository;

  AppRouter({
    @required this.spotifyRepository,
    @required this.authRepository,
  }) : super();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginPage(
            authRepository: authRepository,
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(
            bottomRouter: BottomRouter(
              spotifyRepository: spotifyRepository,
              authRepository: authRepository,
            ),
          ),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegisterPage(
            authRepository: authRepository,
          ),
        );
      default:
        return null;
    }
  }
}
