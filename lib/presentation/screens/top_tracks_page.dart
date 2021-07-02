import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/constants/strings.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/logic/bloc/spotify_player/spotify_player_bloc.dart';
import 'package:spotify_clone/logic/bloc/top_tracks/top_tracks_bloc.dart';
import 'package:spotify_clone/logic/cubit/internet_connection/internet_connection_cubit.dart';
import 'package:spotify_clone/presentation/widgets/track_loader.dart';
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
  TopTracksBloc _topTracksBloc;
  bool _sendingPetition = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _topTracksBloc = context.read<TopTracksBloc>();
  }

  @override
  Widget build(BuildContext homeScreenContext) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: BlocListener<TopTracksBloc, TopTracksState>(
          listener: (context, state) {
            if (state.scrollToTop) {
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(
                  milliseconds: 500,
                ),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<TopTracksBloc, TopTracksState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case TracksStatus.Failure:
                        return state.topTracksPagingResponse == null ||
                                state.topTracksPagingResponse.tracks.isEmpty
                            ? Center(
                                child: _buildRetry(true),
                              )
                            : _buildTopTrackList(state);

                        break;
                      case TracksStatus.Success:
                        if (state.topTracksPagingResponse.tracks.isEmpty) {
                          return Center(
                            child: Text(no_tracks),
                          );
                        }
                        return _buildTopTrackList(state);
                        break;
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
      ),
    );
  }

  Widget _buildTopTrackList(TopTracksState state) {
    int length = state.topTracksPagingResponse.tracks.length;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return index >= length
            ? state.status == TracksStatus.Failure && !state.hasReachedEnd
                ? _buildRetry(state.topTracksPagingResponse.tracks.isEmpty)
                : TrackLoader()
            : _buildTrackWidget(state.topTracksPagingResponse.tracks[index]);
      },
      itemCount: state.hasReachedEnd ? length : length + 1,
      controller: _scrollController,
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
      errorPlaying: false,
    );
  }

  Widget _buildRetry(bool emptyList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(failed_to_fetch_tracks),
          BlocBuilder<InternetConnectionCubit, InternetConnectionState>(
            builder: (context, state) {
              if (state is InternetConnectedState) {
                return ElevatedButton(
                  onPressed: () {
                    _topTracksBloc
                      ..add(emptyList ? TopTracksReset() : TopTracksFetch());
                  },
                  child: Text(retry),
                );
              } else {
                return Text(please_check_internet);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> removeFromLibrary(Track track) async {
    _topTracksBloc.add(
      TopTracksRemoveTrackFromLibrary(track: track),
    );
  }

  Future<void> addToLibrary(Track track) async {
    _topTracksBloc.add(
      TopTracksAddTrackToLibrary(track: track),
    );
  }

  Future<void> play(Track track) async {
    context.read<SpotifyPlayerBloc>().add(SpotifyPlayerPlay(track: track));
  }

  void _onScroll() async {
    if (_isBottom && !_sendingPetition) {
      _topTracksBloc.add(TopTracksFetch());
      _sendingPetition = true;
      Future.delayed(Duration(milliseconds: 1000), () {
        _sendingPetition = false;
      });
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _pullRefresh() async {
    _topTracksBloc..add(TopTracksReset());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
