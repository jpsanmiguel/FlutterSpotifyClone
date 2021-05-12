import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';

part 'top_tracks_state.dart';

class TopTracksCubit extends Cubit<TopTracksState> {
  final Repository repository;

  TopTracksCubit({@required this.repository}) : super(TopTracksInitial());

  void fetchUserTopTracks() async {
    final tracksPagingResponse = await repository.fetchUserTopTracks();
    emit(TopTracksLoaded(topTracksPagingResponse: tracksPagingResponse));
  }
}
