import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/amplifyconfiguration.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/data/services/network_service.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/logic/bloc/top_tracks/top_tracks_bloc.dart';
import 'package:spotify_clone/logic/cubit/internet_connection/internet_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/models/ModelProvider.dart';
import 'package:spotify_clone/presentation/navigation/app_navigator.dart';
import 'package:spotify_clone/presentation/screens/splash_page.dart';

import 'logic/bloc/saved_tracks/saved_tracks_bloc.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => DataRepository(),
        ),
        RepositoryProvider(
          create: (context) => SpotifyRepository(
            networkService: NetworkService(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _finishedConfiguring = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: _finishedConfiguring
          ? MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SpotifyPlayerCubit(
                      spotifyRepository: context.read<SpotifyRepository>()),
                ),
                BlocProvider(
                  create: (context) => SessionCubit(
                    authRepository: context.read<AuthRepository>(),
                    dataRepository: context.read<DataRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => InternetConnectionCubit(
                    connectivity: Connectivity(),
                  ),
                ),
                BlocProvider(
                  create: (context) => TopTracksBloc(
                    spotifyRepository: context.read<SpotifyRepository>(),
                  )..add(TopTracksFetched()),
                ),
                BlocProvider(
                  create: (context) => SavedTracksBloc(
                    spotifyRepository: context.read<SpotifyRepository>(),
                  )..add(SavedTracksFetched()),
                ),
              ],
              child: AppNavigator(
                spotifyRepository: context.read<SpotifyRepository>(),
              ),
            )
          : SplashPage(),
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
    );
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(),
      ]);

      await Amplify.configure(amplifyconfig);

      setState(() {
        _finishedConfiguring = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
