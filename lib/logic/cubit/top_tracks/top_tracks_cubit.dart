import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';

part 'top_tracks_state.dart';

class TopTracksCubit extends Cubit<TopTracksState> {
  final SpotifyRepository spotifyRepository;

  TopTracksCubit({@required this.spotifyRepository})
      : super(TopTracksInitial());

  String nextUrl;
  bool hasReachedEnd = false;
  List<Track> tracks = [];
  TopTracksPagingResponse topTracksPagingResponse;
  bool hasInternetConnection = true;

  void fetchUserTopTracks() async {
    if (hasInternetConnection) {
      if (!(state is TopTracksLoadingMore)) {
        if (!hasReachedEnd) {
          if (tracks.isEmpty) {
            emit(TopTracksLoading());
          } else {
            emit(TopTracksLoadingMore(
                hasReachedEnd: hasReachedEnd,
                topTracksPagingResponse: topTracksPagingResponse));
          }
          print('call to fetch');
          topTracksPagingResponse =
              await spotifyRepository.fetchUserTopTracks(nextUrl);
          nextUrl = topTracksPagingResponse.next;
          if (topTracksPagingResponse.next == null) {
            hasReachedEnd = true;
          }
          tracks = tracks + topTracksPagingResponse.tracks;

          final fullTracksPagingResponse = topTracksPagingResponse;
          fullTracksPagingResponse.tracks = tracks;
          emit(TopTracksLoadedMore(
              topTracksPagingResponse: fullTracksPagingResponse,
              hasReachedEnd: hasReachedEnd));
        }
      }
    }
  }

  Future removeFromLibrary(Track track) async {
    if (hasInternetConnection) {
      await spotifyRepository.removeFromLibrary(track);
      track.inLibrary = false;
      if (state is TopTracksLoaded) {
        emit(TopTracksLoaded(topTracksPagingResponse: topTracksPagingResponse));
      }
      if (state is TopTracksLoadedMore) {
        emit(TopTracksLoadedMore(
            topTracksPagingResponse: topTracksPagingResponse,
            hasReachedEnd: hasReachedEnd));
      }
    }
  }

  Future addToLibrary(Track track) async {
    if (hasInternetConnection) {
      await spotifyRepository.addToLibrary(track);
      track.inLibrary = true;
      if (state is TopTracksLoaded) {
        emit(TopTracksLoaded(topTracksPagingResponse: topTracksPagingResponse));
      }
      if (state is TopTracksLoadedMore) {
        emit(TopTracksLoadedMore(
            topTracksPagingResponse: topTracksPagingResponse,
            hasReachedEnd: hasReachedEnd));
      }
    }
  }

  void resetTopTracks() async {
    if (hasInternetConnection) {
      emit(TopTracksInitial());
      nextUrl = null;
      hasReachedEnd = false;
      tracks = [];
      topTracksPagingResponse = null;
      fetchUserTopTracks();
    }
  }

  void interneConnection(ConnectionType connectionType) {
    if (connectionType == ConnectionType.None) {
      hasInternetConnection = false;
    } else {
      hasInternetConnection = true;
    }
  }
}