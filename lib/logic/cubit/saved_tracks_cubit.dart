import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repository.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';

part 'saved_tracks_state.dart';

class SavedTracksCubit extends Cubit<SavedTracksState> {
  final Repository repository;

  SavedTracksCubit({@required this.repository}) : super(SavedTracksInitial());

  void fetchUserSavedTracks() async {
    final tracksPagingResponse = await repository.fetchUserSavedTracks();
    emit(SavedTracksLoaded(savedTracksPagingResponse: tracksPagingResponse));
  }
}
