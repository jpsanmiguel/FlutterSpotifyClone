import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks_cubit.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  _HomeScreenState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext homeScreenContext) {
    BlocProvider.of<TopTracksCubit>(context).fetchUserTopTracks();
    BlocProvider.of<SavedTracksCubit>(context).fetchUserSavedTracks();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 32.0,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          BlocBuilder<TopTracksCubit, TopTracksState>(
            builder: (context, state) {
              if (state is TopTracksLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TopTracksLoadedMore) {
                int length = state.topTracksPagingResponse.tracks.length;
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index != length
                        ? TrackWidget(
                            backgroundColor: greyColor,
                            icon: Icons.favorite,
                            iconColor: greenColor,
                            onItemPressed: play,
                            track: state.topTracksPagingResponse.tracks[index],
                          )
                        : Container(
                            height: 80.0,
                          );
                  },
                  itemCount: length + 1,
                  controller: _scrollController,
                );

                // return SingleChildScrollView(
                //   controller: _scrollController,
                //   child: Column(
                //     children: state.topTracksPagingResponse.tracks
                //         .map((track) => _buildTopTrack(track))
                //         .toList(),
                //   ),
                // );
              } else {
                return Container();
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<SpotifyPlayerCubit, SpotifyPlayerState>(
                      builder: (context, state) {
                        if (state is SpotifyPlayerInitial) {
                          return Container();
                        } else if (state is SpotifyPlayerConnecting) {
                          return Container(
                            decoration: BoxDecoration(
                              color: blackColor,
                            ),
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: CircularProgressIndicator(),
                                  height: 20.0,
                                  width: 20.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                ),
                                Text('Connecting...'),
                              ],
                            ),
                          );
                        } else if (state is SpotifyPlayerConnected) {
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
                            backgroundColor: blackColor,
                            icon: Icons.pause,
                            iconColor: whiteColor,
                            onIconPressed: pause,
                            track: state.track,
                          );
                        } else if (state is SpotifyPlayerPaused) {
                          return TrackWidget(
                            backgroundColor: blackColor,
                            icon: Icons.play_arrow,
                            iconColor: whiteColor,
                            onIconPressed: resume,
                            track: state.track,
                          );
                        } else {
                          return Container();
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
    );
  }

  Future<void> play(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).play(track);
  }

  Future<void> pause(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).pause(track);
  }

  Future<void> resume(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).resume(track);
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      print('call to fetch');
      BlocProvider.of<TopTracksCubit>(context).fetchUserTopTracks();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
