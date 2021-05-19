import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/internet_connection/internet_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/presentation/navigation/router/bottom_router.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, @required this.bottomRouter}) : super(key: key);

  final BottomRouter bottomRouter;

  @override
  _HomePageState createState() => _HomePageState(bottomRouter: bottomRouter);
}

class _HomePageState extends State<HomePage> {
  final BottomRouter bottomRouter;

  _HomePageState({this.bottomRouter});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SpotifyPlayerCubit>(context).connectToSpotifyRemote();

    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      listener: (context, state) {
        if (state is InternetConnectedState) {
          print('Internet connection!');
        } else if (state is InternetDisconnectedState) {
          print('No internet connection!');
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Navigator(
                  key: _navigatorKey,
                  onGenerateRoute: bottomRouter.onGenerateRoute),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<InternetConnectionCubit,
                          InternetConnectionState>(
                        builder: (context, state) {
                          if (state is InternetDisconnectedState) {
                            return Container(
                              margin: EdgeInsets.all(4.0),
                              child: Text(
                                'No internet connection!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
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
                          if (state is SpotifyPlayerError) {
                            loading = false;
                            final snackBar = SnackBar(
                              content: Text(state.error),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (state is SpotifyPlayerLoading) {
                            loading = true;
                            Future.delayed(Duration(seconds: 5), () {
                              if (loading) {
                                BlocProvider.of<SpotifyPlayerCubit>(context)
                                    .errorPlayingTrack(
                                        'Error reproduciendo...');
                              }
                            });
                          } else {
                            loading = false;
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
      ),
    );
  }

  Future<void> pause(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).pause(track);
  }

  Future<void> resume(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).resume(track);
  }

  Widget _bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: blackColor,
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
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
      ),
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
