import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks_cubit.dart';
import 'package:spotify_clone/presentation/screens/home_screen.dart';

class AppRouter {
  final Repository repository;

  AppRouter({@required this.repository}) : super();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) =>
                            TopTracksCubit(repository: repository)),
                    BlocProvider(
                        create: (context) =>
                            SavedTracksCubit(repository: repository)),
                  ],
                  child: HomeScreen(),
                ));
      default:
        return null;
    }
  }
}
