import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';

part 'top_tracks_state.dart';

class TopTracksCubit extends Cubit<TopTracksState> {
  final Repository repository;

  TopTracksCubit({@required this.repository}) : super(TopTracksInitial());

  String nextUrl;
  bool hasReachedEnd = false;
  List<Track> tracks = [];
  TopTracksPagingResponse topTracksPagingResponse;

  void fetchUserTopTracks() async {
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
        topTracksPagingResponse = await repository.fetchUserTopTracks(nextUrl);
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

  Future<bool> connectToSpotifyRemote() async {
    return await repository.connectToSpotifyRemote();
  }
}
