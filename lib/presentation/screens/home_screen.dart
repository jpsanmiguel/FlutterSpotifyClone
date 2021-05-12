import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks_cubit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.color}) : super(key: key);

  final String title;
  final Color color;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 300.0;
  double _historicMaxScroll = 0.0;

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
        title: Text('Test!'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings')),
        ],
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
    return ListTile(
      contentPadding: EdgeInsets.all(8.0),
      leading: Image.network('${track.getImageUrl()}'),
      title: Text(track.name),
      subtitle: Text(track.getArtistsNames()),
    );
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // if (currentScroll >= maxScroll - _scrollThreshold &&
    //     _historicMaxScroll != maxScroll) {
    if (currentScroll == maxScroll) {
      _historicMaxScroll = maxScroll;
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
