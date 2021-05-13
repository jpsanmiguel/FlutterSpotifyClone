import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks_cubit.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class TopTracksPage extends StatefulWidget {
  TopTracksPage({Key key}) : super(key: key);

  @override
  _TopTracksPageState createState() => _TopTracksPageState();
}

class _TopTracksPageState extends State<TopTracksPage> {
  final _scrollController = ScrollController();

  _TopTracksPageState() {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext homeScreenContext) {
    BlocProvider.of<TopTracksCubit>(context).fetchUserTopTracks();
    BlocProvider.of<SavedTracksCubit>(context).fetchUserSavedTracks();
    BlocProvider.of<SpotifyPlayerCubit>(context).connectToSpotifyRemote();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top tracks'),
        // title: Image.asset(
        //   'assets/images/logo.png',
        //   fit: BoxFit.contain,
        //   height: 32.0,
        // ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TopTracksCubit, TopTracksState>(
              builder: (context, state) {
                if (state is TopTracksLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopTracksLoadedMore) {
                  int length = state.topTracksPagingResponse.tracks.length;
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return TrackWidget(
                        backgroundColor: blackColor,
                        icon: Icons.favorite,
                        iconColor: greenColor,
                        onItemPressed: play,
                        track: state.topTracksPagingResponse.tracks[index],
                        loading: false,
                        isPlaying: false,
                      );
                    },
                    itemCount: length,
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
