import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/bloc/saved_tracks/saved_tracks_bloc.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/models/User.dart';
import 'package:spotify_clone/presentation/widgets/track_loader.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class SavedTracksPage extends StatefulWidget {
  final User user;
  SavedTracksPage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _SavedTracksPageState createState() => _SavedTracksPageState(user: user);
}

class _SavedTracksPageState extends State<SavedTracksPage> {
  final User user;
  final _scrollController = ScrollController();

  _SavedTracksPageState({@required this.user}) {
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext homeScreenContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved tracks of ${user.username}',
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
              child: BlocBuilder<SavedTracksBloc, SavedTracksState>(
                builder: (context, state) {
                  switch (state.status) {
                    case TracksStatus.Failure:
                      return Center(
                        child: Text('Failed to fetch tracks'),
                      );
                      break;
                    case TracksStatus.Success:
                      if (state.savedTracksPagingResponse.tracks.isEmpty) {
                        return Center(
                          child: Text('No tracks'),
                        );
                      }
                      int length =
                          state.savedTracksPagingResponse.tracks.length;
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return index >= length
                              ? TrackLoader()
                              : _buildTrackWidget(state
                                  .savedTracksPagingResponse
                                  .tracks[index]
                                  .track);
                        },
                        itemCount: state.hasReachedEnd ? length : length + 1,
                        controller: _scrollController,
                      );
                    default:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TrackWidget _buildTrackWidget(Track track) {
    return TrackWidget(
      backgroundColor: blackColor,
      icon: track.inLibrary ? Icons.favorite : Icons.favorite_border,
      iconColor: greenColor,
      onIconPressed: track.inLibrary ? removeFromLibrary : addToLibrary,
      onItemPressed: play,
      track: track,
      loading: false,
      isPlaying: false,
    );
  }

  Future<void> play(Track track) async {
    context.read<SpotifyPlayerCubit>().play(track);
  }

  Future<void> removeFromLibrary(Track track) async {
    context.read<SavedTracksBloc>().add(
          SavedTracksRemoveTrackToLibrary(track: track),
        );
  }

  Future<void> addToLibrary(Track track) async {
    context.read<SavedTracksBloc>().add(
          SavedTracksAddTrackToLibrary(track: track),
        );
  }

  void _onScroll() async {
    if (_isBottom) context.read<SavedTracksBloc>().add(SavedTracksFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _pullRefresh() async {
    context.read<SavedTracksBloc>()..add(SavedTracksReset());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
