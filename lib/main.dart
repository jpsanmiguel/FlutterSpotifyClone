import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/amplifyconfiguration.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/strings.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/data/services/network_service.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/logic/bloc/profile/profile_bloc.dart';
import 'package:spotify_clone/logic/bloc/top_tracks/top_tracks_bloc.dart';
import 'package:spotify_clone/logic/cubit/internet_connection/internet_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';
import 'package:spotify_clone/data/models/aws/ModelProvider.dart';
import 'package:spotify_clone/presentation/navigation/app_navigator.dart';
import 'package:spotify_clone/presentation/screens/splash_page.dart';

import 'logic/bloc/saved_tracks/saved_tracks_bloc.dart';
import 'logic/bloc/spotify_player/spotify_player_bloc.dart';

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
      title: app_title,
      theme: ThemeData(
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
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: greenColor),
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
                  create: (context) => AuthSessionCubit(
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
                  )..add(TopTracksFetch()),
                ),
                BlocProvider(
                  create: (context) => SavedTracksBloc(
                    spotifyRepository: context.read<SpotifyRepository>(),
                  )..add(SavedTracksFetch()),
                ),
                BlocProvider(
                  create: (context) => SpotifyPlayerBloc(
                    spotifyRepository: context.read<SpotifyRepository>(),
                  )..add(SpotifyPlayerConnect()),
                ),
                BlocProvider(
                  create: (context) => ProfileBloc(
                    dataRepository: context.read<DataRepository>(),
                  ),
                )
              ],
              child: AppNavigator(
                spotifyRepository: context.read<SpotifyRepository>(),
              ),
            )
          : SplashPage(),
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
