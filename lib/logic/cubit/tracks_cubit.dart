import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/data/response/tracks_paging_response.dart';

part 'tracks_state.dart';

class TracksCubit extends Cubit<TracksState> {
  final Repository repository;

  TracksCubit({@required this.repository}) : super(TracksInitial());

  void fetchUserTopTracks() async {
    final tracksPagingResponse = await repository.fetchUserTopTracks();
    emit(TracksLoaded(tracksPagingResponse: tracksPagingResponse));
  }
}
