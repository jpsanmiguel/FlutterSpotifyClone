import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/constants/strings.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/bloc/top_tracks/top_tracks_bloc.dart';
import 'package:spotify_clone/logic/cubit/internet_connection/internet_connection_cubit.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';
import 'package:spotify_clone/logic/cubit/spotify_player/spotify_player_cubit.dart';
import 'package:spotify_clone/presentation/widgets/track_widget.dart';

class TopTracksPage extends StatefulWidget {
  TopTracksPage({
    Key key,
  }) : super(key: key);

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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TopTracksBloc, TopTracksState>(
                builder: (context, state) {
                  switch (state.status) {
                    case TracksStatus.Failure:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Failed to fetch tracks'),
                            BlocBuilder<InternetConnectionCubit,
                                InternetConnectionState>(
                              builder: (context, state) {
                                if (state is InternetConnectedState) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      context.read<TopTracksBloc>()
                                        ..add(TopTracksReset());
                                    },
                                    child: Text('Retry'),
                                  );
                                } else {
                                  return Text(NO_INTERNET);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                      break;
                    case TracksStatus.Success:
                      if (state.topTracksPagingResponse.tracks.isEmpty) {
                        return Center(
                          child: Text('No tracks'),
                        );
                      }
                      int length = state.topTracksPagingResponse.tracks.length;
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return index >= length
                              ? CircularProgressIndicator()
                              : _buildTrackWidget(
                                  state.topTracksPagingResponse.tracks[index]);
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

  Future<void> removeFromLibrary(Track track) async {
    context.read<TopTracksBloc>().add(
          TopTracksRemoveTrackToLibrary(track: track),
        );
  }

  Future<void> addToLibrary(Track track) async {
    context.read<TopTracksBloc>().add(
          TopTracksAddTrackToLibrary(track: track),
        );
  }

  Future<void> play(Track track) async {
    BlocProvider.of<SpotifyPlayerCubit>(context).play(track);
  }

  void _onScroll() async {
    if (_isBottom) context.read<TopTracksBloc>().add(TopTracksFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _pullRefresh() async {
    context.read<TopTracksBloc>()..add(TopTracksReset());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
