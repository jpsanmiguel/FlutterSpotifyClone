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

  var _scrollThreshold = 0.0;

  @override
  Widget build(BuildContext homeScreenContext) {
    BlocProvider.of<TopTracksCubit>(context).fetchUserTopTracks();
    BlocProvider.of<SavedTracksCubit>(context).fetchUserSavedTracks();

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
                } else if (state is TopTracksLoadingMore) {
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
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> play(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).play(track);
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (_scrollThreshold == 0.0) _scrollThreshold = maxScroll / 2;
    if (currentScroll >= maxScroll - _scrollThreshold) {
      BlocProvider.of<TopTracksCubit>(context).fetchUserTopTracks();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
