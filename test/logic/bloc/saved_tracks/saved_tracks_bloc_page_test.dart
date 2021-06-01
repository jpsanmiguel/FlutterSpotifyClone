import 'package:bloc_test/bloc_test.dart' as blocTest;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/response/saved_tracks_paging_response.dart';
import 'package:spotify_clone/logic/bloc/saved_tracks/saved_tracks_bloc.dart';

import '../../../mocks/mock_spotify_repository.dart';
import '../../../utils.dart';

void main() {
  MockSpotifyRepository mockSpotifyRepository;

  setUp(() {
    mockSpotifyRepository = MockSpotifyRepository();
  });

  group('Connection changed', () {
    blocTest.blocTest(
      'Changed connection',
      build: () => SavedTracksBloc(spotifyRepository: mockSpotifyRepository),
      act: (bloc) {
        bloc
          ..add(SavedTracksConnectionChanged(
            connectionType: ConnectionType.Mobile,
          ))
          ..add(SavedTracksConnectionChanged(
            connectionType: ConnectionType.Wifi,
          ))
          ..add(SavedTracksConnectionChanged(
            connectionType: ConnectionType.None,
          ))
          ..add(SavedTracksConnectionChanged(
            connectionType: ConnectionType.Wifi,
          ));
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Initial,
          hasReachedEnd: false,
          connectionType: ConnectionType.Mobile,
          scrollToTop: false,
        ),
        SavedTracksState(
          status: TracksStatus.Initial,
          hasReachedEnd: false,
          connectionType: ConnectionType.Wifi,
          scrollToTop: false,
        ),
        SavedTracksState(
          status: TracksStatus.Failure,
          hasReachedEnd: false,
          connectionType: ConnectionType.None,
          scrollToTop: false,
        ),
        SavedTracksState(
          status: TracksStatus.Failure,
          hasReachedEnd: false,
          connectionType: ConnectionType.Wifi,
          scrollToTop: false,
        ),
      ],
    );
  });

  group('Request initial tracks', () {
    final savedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(10);
    blocTest.blocTest(
      'Request initial tracks success',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async {
          return savedTracksPagingResponse;
        });
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(SavedTracksFetch());
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: savedTracksPagingResponse,
          hasReachedEnd: false,
        ),
      ],
    );

    blocTest.blocTest(
      'Request initial tracks failure',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenThrow(Exception());
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(SavedTracksFetch());
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Failure,
        ),
      ],
    );
  });

  group('Request more tracks', () {
    SavedTracksPagingResponse initialSavedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(10);
    SavedTracksPagingResponse moreSavedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(10);
    blocTest.blocTest(
      'Request more tracks success',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async {
          return initialSavedTracksPagingResponse;
        });
        when(mockSpotifyRepository.fetchMoreUserSavedTracks(
          nextUrl: anyNamed('nextUrl'),
        )).thenAnswer((_) async {
          return moreSavedTracksPagingResponse;
        });
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(SavedTracksFetch())..add(SavedTracksFetch());
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
          hasReachedEnd: false,
        ),
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: moreSavedTracksPagingResponse,
          hasReachedEnd: false,
        ),
      ],
    );

    blocTest.blocTest(
      'Request more tracks failure',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async {
          return initialSavedTracksPagingResponse;
        });
        when(mockSpotifyRepository.fetchMoreUserSavedTracks(
          nextUrl: anyNamed('nextUrl'),
        )).thenThrow(Exception());
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(SavedTracksFetch())..add(SavedTracksFetch());
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
          hasReachedEnd: false,
        ),
        SavedTracksState(
          status: TracksStatus.Failure,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
      ],
    );
  });

  group('Add track to library', () {
    SavedTracksPagingResponse initialSavedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(10);
    blocTest.blocTest(
      'Add track to library success',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async {
          return initialSavedTracksPagingResponse;
        });
        when(mockSpotifyRepository.addToLibrary(any))
            .thenAnswer((_) async => true);
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(SavedTracksFetch())
          ..add(SavedTracksAddTrackToLibrary(track: randomTrack()));
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
      ],
    );
  });
}
