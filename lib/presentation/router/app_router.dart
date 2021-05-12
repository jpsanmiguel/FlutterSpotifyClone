import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/logic/cubit/tracks_cubit.dart';
import 'package:spotify_clone/presentation/screens/home_screen.dart';

class AppRouter {
  final Repository repository;

  AppRouter({@required this.repository}) : super();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => TracksCubit(repository: repository),
                  child: HomeScreen(),
                ));
      default:
        return null;
    }
  }
}
