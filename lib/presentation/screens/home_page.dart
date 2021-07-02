import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/constants/strings.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/bloc/saved_tracks/saved_tracks_bloc.dart';
import 'package:spotify_clone/logic/bloc/spotify_player/spotify_player_bloc.dart';
import 'package:spotify_clone/logic/bloc/top_tracks/top_tracks_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';
import 'package:spotify_clone/logic/cubit/internet_connection/internet_connection_cubit.dart';
import 'package:spotify_clone/models/ModelProvider.dart';
import 'package:spotify_clone/presentation/screens/profile_page.dart';
import 'package:spotify_clone/presentation/screens/saved_tracks_page.dart';
import 'package:spotify_clone/presentation/screens/top_tracks_page.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';
import 'package:spotify_clone/utils/functions.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthSessionCubit>().currentUser;
    final titles = [
      '$top_tracks_of_title${user.username}',
      '$saved_tracks_of_title${user.username}',
      '$profile_of_title${user.username}',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_currentTabIndex],
          style: TextStyle(
            color: textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: textColor,
            ),
            onPressed: () => context.read<AuthSessionCubit>().signOut(),
          ),
        ],
        backgroundColor: darkGreyColor,
        centerTitle: true,
      ),
      body: BlocListener<InternetConnectionCubit, InternetConnectionState>(
        listener: (context, state) {
          if (state is InternetConnectedState) {
            _addConnectionChanged(state.connectionType);
          } else if (state is InternetDisconnectedState) {
            _addConnectionChanged(ConnectionType.None);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  TopTracksPage(),
                  SavedTracksPage(),
                  ProfilePage(),
                ],
              ),
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
                                no_internet,
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
                      BlocConsumer<SpotifyPlayerBloc, SpotifyPlayerState>(
                        builder: (context, state) {
                          if (state.error != null) {
                            return TrackWidget(
                              backgroundColor: darkGreyColor,
                              icon: Icons.play_arrow,
                              iconColor: whiteColor,
                              onIconPressed: resume,
                              track: state.track,
                              loading: false,
                              isPlaying: true,
                              errorPlaying: true,
                            );
                          } else if (state.connectionStatus ==
                                  SpotifyPlayerConnectionStatus.Connecting ||
                              state.reproductionStatus ==
                                  SpotifyPlayerReproductionStatus.Loading) {
                            return TrackWidget(
                              backgroundColor: darkGreyColor,
                              loading: true,
                              isPlaying: true,
                              errorPlaying: false,
                            );
                          } else if (state.reproductionStatus ==
                              SpotifyPlayerReproductionStatus.Playing) {
                            return TrackWidget(
                              backgroundColor: darkGreyColor,
                              icon: Icons.pause,
                              iconColor: whiteColor,
                              onIconPressed: pause,
                              track: state.track,
                              loading: false,
                              isPlaying: true,
                              errorPlaying: false,
                            );
                          } else if (state.reproductionStatus ==
                              SpotifyPlayerReproductionStatus.Paused) {
                            return TrackWidget(
                              backgroundColor: darkGreyColor,
                              icon: Icons.play_arrow,
                              iconColor: whiteColor,
                              onIconPressed: resume,
                              track: state.track,
                              loading: false,
                              isPlaying: true,
                              errorPlaying: false,
                            );
                          } else {
                            return Container();
                          }
                        },
                        listener: (context, state) {
                          if (state.connectionStatus ==
                              SpotifyPlayerConnectionStatus.Disconnected) {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            context
                                .read<SpotifyPlayerBloc>()
                                .add(SpotifyPlayerConnect());
                          } else if (state.error != null) {
                            showSnackBar(context, state.error);
                          } else {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
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
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  void _addConnectionChanged(ConnectionType connectionType) {
    context.read<SavedTracksBloc>().add(
          SavedTracksConnectionChanged(connectionType: connectionType),
        );
    context.read<TopTracksBloc>().add(
          TopTracksConnectionChanged(connectionType: connectionType),
        );
  }

  Future<void> pause(Track track) async {
    context.read<SpotifyPlayerBloc>().add(SpotifyPlayerPause(track: track));
  }

  Future<void> resume(Track track) async {
    context.read<SpotifyPlayerBloc>().add(SpotifyPlayerResume());
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
            label: top_tracks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: saved_tracks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: profile,
          ),
        ],
        onTap: _onTap,
        currentIndex: _currentTabIndex,
      ),
    );
  }

  _onTap(int tabIndex) {
    if (_currentTabIndex == tabIndex) {
      if (tabIndex == 0) {
        context.read<TopTracksBloc>().add(TopTracksScrollTop());
      } else if (tabIndex == 1) {
        context.read<SavedTracksBloc>().add(SavedTracksScrollTop());
      }
    } else {
      setState(() {
        _currentTabIndex = tabIndex;
      });
    }
  }
}
