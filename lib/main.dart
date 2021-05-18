import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/services/network_service.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks/top_tracks_cubit.dart';
import 'package:spotify_clone/presentation/navigation/app_navigator.dart';
import 'package:spotify_clone/presentation/navigation/app_router.dart';
import 'package:spotify_clone/presentation/navigation/auth_navigator.dart';
import 'package:spotify_clone/presentation/navigation/router/bottom_router.dart';

void main() {
  NetworkService networkService = NetworkService();
  AuthRepository authRepository = AuthRepository();
  SpotifyRepository spotifyRepository =
      SpotifyRepository(networkService: networkService);
  TopTracksCubit topTracksCubit = TopTracksCubit(repository: spotifyRepository);
  SavedTracksCubit savedTracksCubit =
      SavedTracksCubit(repository: spotifyRepository);
  SpotifyPlayerCubit spotifyConnectionCubit =
      SpotifyPlayerCubit(repository: spotifyRepository);
  SessionCubit sessionCubit = SessionCubit(authRepository: authRepository);
  BottomRouter bottomRouter = BottomRouter(
      spotifyRepository: spotifyRepository, authRepository: authRepository);
  runApp(MyApp(
    appRouter: AppRouter(
      spotifyRepository: spotifyRepository,
      authRepository: authRepository,
    ),
    authRepository: authRepository,
    topTracksCubit: topTracksCubit,
    savedTracksCubit: savedTracksCubit,
    spotifyConnectionCubit: spotifyConnectionCubit,
    sessionCubit: sessionCubit,
    bottomRouter: bottomRouter,
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final SavedTracksCubit savedTracksCubit;
  final TopTracksCubit topTracksCubit;
  final SpotifyPlayerCubit spotifyConnectionCubit;
  final AuthRepository authRepository;
  final SessionCubit sessionCubit;
  final BottomRouter bottomRouter;

  const MyApp({
    Key key,
    @required this.appRouter,
    @required this.authRepository,
    @required this.spotifyConnectionCubit,
    @required this.savedTracksCubit,
    @required this.topTracksCubit,
    @required this.sessionCubit,
    @required this.bottomRouter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: topTracksCubit,
        ),
        BlocProvider.value(
          value: savedTracksCubit,
        ),
        BlocProvider.value(
          value: spotifyConnectionCubit,
        ),
        BlocProvider.value(
          value: sessionCubit,
        ),
      ],
      child: MaterialApp(
        title: 'Spotify Clone',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          focusColor: greenColor,
          primarySwatch: greenColor,
          scaffoldBackgroundColor: blackColor,
          hintColor: hintTextColor,
          primaryColor: greenColor,
          accentColor: greenColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: lightGreyColor),
              //  when the TextFormField in unfocused
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: greenColor),
              //  when the TextFormField in focused
            ),
            border: UnderlineInputBorder(),
          ),
          brightness: Brightness.dark,
          snackBarTheme: SnackBarThemeData(
            actionTextColor: textColor,
            backgroundColor: darkGreyColor,
            contentTextStyle: TextStyle(
              color: textColor,
            ),
          ),
        ),
        home: AppNavigator(
          authRepository: authRepository,
          bottomRouter: bottomRouter,
        ),
        // home: MultiBlocProvider(
        //   providers: [
        //     BlocProvider.value(
        //       value: topTracksCubit,
        //     ),
        //     BlocProvider.value(
        //       value: savedTracksCubit,
        //     ),
        //     BlocProvider.value(value: spotifyConnectionCubit)
        //   ],
        //   child: LoginPage(
        //     authRepository: authRepository,
        //   ),
        //   // child: HomePage(
        //   //   appRouter: appRouter,
        //   // ),
        // ),
      ),
    );
  }
}
