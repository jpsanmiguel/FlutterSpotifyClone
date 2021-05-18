import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/amplifyconfiguration.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/data/services/network_service.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks/top_tracks_cubit.dart';
import 'package:spotify_clone/models/ModelProvider.dart';
import 'package:spotify_clone/presentation/navigation/app_navigator.dart';
import 'package:spotify_clone/presentation/screens/splash_page.dart';

void main() {
  NetworkService networkService = NetworkService();
  SpotifyRepository spotifyRepository =
      SpotifyRepository(networkService: networkService);
  TopTracksCubit topTracksCubit = TopTracksCubit(repository: spotifyRepository);
  SavedTracksCubit savedTracksCubit =
      SavedTracksCubit(repository: spotifyRepository);
  SpotifyPlayerCubit spotifyConnectionCubit =
      SpotifyPlayerCubit(repository: spotifyRepository);
  runApp(MyApp(
    topTracksCubit: topTracksCubit,
    savedTracksCubit: savedTracksCubit,
    spotifyConnectionCubit: spotifyConnectionCubit,
    spotifyRepository: spotifyRepository,
  ));
}

class MyApp extends StatefulWidget {
  final SavedTracksCubit savedTracksCubit;
  final TopTracksCubit topTracksCubit;
  final SpotifyPlayerCubit spotifyConnectionCubit;
  final SpotifyRepository spotifyRepository;

  const MyApp({
    Key key,
    @required this.spotifyConnectionCubit,
    @required this.savedTracksCubit,
    @required this.topTracksCubit,
    @required this.spotifyRepository,
  }) : super(key: key);

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => DataRepository(),
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
        home: _finishedConfiguring
            ? MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: widget.topTracksCubit,
                  ),
                  BlocProvider.value(
                    value: widget.savedTracksCubit,
                  ),
                  BlocProvider.value(
                    value: widget.spotifyConnectionCubit,
                  ),
                  BlocProvider(
                    create: (context) => SessionCubit(
                      authRepository: context.read<AuthRepository>(),
                      dataRepository: context.read<DataRepository>(),
                    ),
                  ),
                ],
                child: AppNavigator(
                  spotifyRepository: widget.spotifyRepository,
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
      ),
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
