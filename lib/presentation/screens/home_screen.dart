import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks_cubit.dart';
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
    BlocProvider.of<TopTracksCubit>(context).connectToSpotifyRemote();

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
      body: BlocBuilder<TopTracksCubit, TopTracksState>(
        builder: (context, state) {
          if (state is TopTracksLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopTracksLoadedMore) {
            int length = state.topTracksPagingResponse.tracks.length;
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _buildTopTrack(
                    state.topTracksPagingResponse.tracks[index]);
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
    );
  }

  Widget _buildTopTrack(Track track) {
    return Container(
      decoration: BoxDecoration(
        color: greyColor,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.network('${track.getImageUrl()}'),
        title: Text(
          track.name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          track.getArtistsNames(),
          style: TextStyle(
            color: textColor,
          ),
        ),
        trailing: Icon(
          Icons.favorite,
          color: greenColor,
        ),
        onTap: () async {
          play(track.uri);
        },
      ),
    );
  }

  Future<void> play(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
    } on PlatformException catch (e) {}
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
