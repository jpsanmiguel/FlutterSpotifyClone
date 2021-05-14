import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/spotify_player_cubit.dart';
import 'package:spotify_clone/presentation/router/app_router.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.appRouter}) : super(key: key);

  final AppRouter appRouter;

  @override
  _HomePageState createState() => _HomePageState(appRouter: appRouter);
}

class _HomePageState extends State<HomePage> {
  final AppRouter appRouter;

  _HomePageState({this.appRouter});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SpotifyPlayerCubit>(context).connectToSpotifyRemote();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Navigator(
                key: _navigatorKey, onGenerateRoute: appRouter.onGenerateRoute),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocConsumer<SpotifyPlayerCubit, SpotifyPlayerState>(
                      builder: (context, state) {
                        if (state is SpotifyPlayerInitial) {
                          return Container();
                        } else if (state is SpotifyPlayerConnecting) {
                          return Container();
                        } else if (state is SpotifyPlayerConnected) {
                          BlocProvider.of<SpotifyPlayerCubit>(context)
                              .listenToPlayerState();
                          return Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: blackColor,
                            ),
                            child: Center(
                              child: Text('Connected!'),
                            ),
                          );
                        } else if (state is SpotifyPlayerPlaying) {
                          return TrackWidget(
                            backgroundColor: darkGreyColor,
                            icon: Icons.pause,
                            iconColor: whiteColor,
                            onIconPressed: pause,
                            track: state.track,
                            loading: false,
                            isPlaying: true,
                          );
                        } else if (state is SpotifyPlayerPaused) {
                          return TrackWidget(
                            backgroundColor: darkGreyColor,
                            icon: Icons.play_arrow,
                            iconColor: whiteColor,
                            onIconPressed: resume,
                            track: state.track,
                            loading: false,
                            isPlaying: true,
                          );
                        } else if (state is SpotifyPlayerLoading) {
                          return TrackWidget(
                            backgroundColor: darkGreyColor,
                            loading: true,
                            isPlaying: true,
                          );
                        } else {
                          return Container();
                        }
                      },
                      listener: (context, state) {
                        if (state is SpotifyPlayerConnectionFailed) {
                          final snackBar = SnackBar(
                            content: Text(state.error),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Future<void> pause(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).pause(track);
  }

  Future<void> resume(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).resume(track);
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: darkGreyColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: greenColor,
      unselectedItemColor: lightGreyColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.thumb_up),
          label: "Top tracks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Saved tracks",
        )
      ],
      onTap: _onTap,
      currentIndex: _currentTabIndex,
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _navigatorKey.currentState.pushReplacementNamed("/");
        break;
      case 1:
        _navigatorKey.currentState.pushReplacementNamed("/saved");
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }
}
