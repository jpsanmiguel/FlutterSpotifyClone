import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks_cubit.dart';
import 'package:spotify_clone/presentation/screens/home_screen.dart';

class AppRouter {
  final Repository repository;
  final SavedTracksCubit savedTracksCubit;
  final TopTracksCubit topTracksCubit;
  final SpotifyPlayerCubit spotifyConnectionCubit;

  AppRouter({
    @required this.spotifyConnectionCubit,
    @required this.savedTracksCubit,
    @required this.topTracksCubit,
    @required this.repository,
  }) : super();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: topTracksCubit,
                    ),
                    BlocProvider.value(
                      value: savedTracksCubit,
                    ),
                    BlocProvider.value(value: spotifyConnectionCubit)
                  ],
                  child: HomeScreen(),
                ));
      default:
        return null;
    }
  }
}
