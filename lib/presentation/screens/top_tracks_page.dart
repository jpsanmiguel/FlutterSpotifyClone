import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/logic/cubit/top_tracks/top_tracks_cubit.dart';
import 'package:spotify_clone/models/User.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class TopTracksPage extends StatefulWidget {
  final User user;
  TopTracksPage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _TopTracksPageState createState() => _TopTracksPageState(user: user);
}

class _TopTracksPageState extends State<TopTracksPage> {
  final User user;
  final _scrollController = ScrollController();

  _TopTracksPageState({@required this.user}) {
    _scrollController.addListener(_onScroll);
  }

  var _scrollThreshold = 0.0;

  @override
  Widget build(BuildContext homeScreenContext) {
    BlocProvider.of<TopTracksCubit>(context).fetchUserTopTracks();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top tracks of ${user.username}',
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
            onPressed: () => context.read<SessionCubit>().signOut(),
          ),
        ],
        backgroundColor: darkGreyColor,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Column(
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
                        Track track =
                            state.topTracksPagingResponse.tracks[index];
                        return TrackWidget(
                          backgroundColor: blackColor,
                          icon: track.inLibrary
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor: greenColor,
                          onIconPressed: track.inLibrary
                              ? removeFromLibrary
                              : addToLibrary,
                          onItemPressed: play,
                          track: track,
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
      ),
    );
  }

  Future<void> removeFromLibrary(Track track) async {
    await BlocProvider.of<TopTracksCubit>(context).removeFromLibrary(track);
  }

  Future<void> addToLibrary(Track track) async {
    await BlocProvider.of<TopTracksCubit>(context).addToLibrary(track);
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

  Future<void> _pullRefresh() async {
    BlocProvider.of<TopTracksCubit>(context).resetTopTracks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
