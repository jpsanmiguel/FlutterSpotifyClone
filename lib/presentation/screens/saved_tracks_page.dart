import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/cubit/saved_tracks/saved_tracks_cubit.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class SavedTracksPage extends StatefulWidget {
  SavedTracksPage({Key key}) : super(key: key);

  @override
  _SavedTracksPageState createState() => _SavedTracksPageState();
}

class _SavedTracksPageState extends State<SavedTracksPage> {
  final _scrollController = ScrollController();

  _SavedTracksPageState() {
    _scrollController.addListener(_onScroll);
  }

  var _scrollThreshold = 0.0;

  @override
  Widget build(BuildContext homeScreenContext) {
    context.read<SavedTracksCubit>().fetchUserSavedTracks();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved tracks',
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
              child: BlocBuilder<SavedTracksCubit, SavedTracksState>(
                builder: (context, state) {
                  if (state is SavedTracksLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SavedTracksLoadedMore) {
                    int length = state.savedTracksPagingResponse.tracks.length;
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        Track track =
                            state.savedTracksPagingResponse.tracks[index].track;
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
                  } else if (state is SavedTracksLoadingMore) {
                    int length = state.savedTracksPagingResponse.tracks.length;
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        Track track =
                            state.savedTracksPagingResponse.tracks[index].track;
                        return TrackWidget(
                          backgroundColor: blackColor,
                          icon: Icons.favorite,
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

  Future<void> play(Track track) async {
    context.read<SpotifyPlayerCubit>().play(track);
  }

  Future<void> removeFromLibrary(Track track) async {
    context.read<SavedTracksCubit>().removeFromLibrary(track);
  }

  Future<void> addToLibrary(Track track) async {
    context.read<SavedTracksCubit>().addToLibrary(track);
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (_scrollThreshold == 0.0) _scrollThreshold = maxScroll / 2;
    if (currentScroll >= maxScroll - _scrollThreshold) {
      context.read<SavedTracksCubit>().fetchUserSavedTracks();
    }
  }

  Future<void> _pullRefresh() async {
    context.read<SavedTracksCubit>().resetSavedTracks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
