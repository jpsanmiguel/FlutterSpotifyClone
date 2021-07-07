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

  group('Request initial tracks with more to load', () {
    final savedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
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
      'Failure',
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

  group('Request initial tracks without more to load', () {
    final savedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: true,
      isInitial: true,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
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
          hasReachedEnd: true,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
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
        randomSavedTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    SavedTracksPagingResponse moreSavedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(
      size: 3,
      isFinal: false,
      isInitial: false,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
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
      'Failure',
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
        randomSavedTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: false,
    );
    final finalSavedTracksPagingResponse =
        initialSavedTracksPagingResponse.copyWith();
    finalSavedTracksPagingResponse.tracks[0].track.inLibrary = true;
    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async {
          return initialSavedTracksPagingResponse;
        });
        when(mockSpotifyRepository.addToLibrary(
          any,
        )).thenAnswer((_) async => true);
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(SavedTracksFetch())
          ..add(SavedTracksAddTrackToLibrary(
            track: initialSavedTracksPagingResponse.tracks[0].track,
          ));
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
          addedTrackToLibrary: true,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async {
          return initialSavedTracksPagingResponse;
        });
        when(mockSpotifyRepository.addToLibrary(any)).thenThrow(Exception());
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(SavedTracksFetch())
          ..add(SavedTracksAddTrackToLibrary(
            track: initialSavedTracksPagingResponse.tracks[0].track,
          ));
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
          addedTrackToLibrary: false,
        ),
      ],
    );
  });

  group('Remove track from library', () {
    SavedTracksPagingResponse initialSavedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    final finalSavedTracksPagingResponse =
        initialSavedTracksPagingResponse.copyWith();
    finalSavedTracksPagingResponse.tracks =
        initialSavedTracksPagingResponse.tracks.sublist(1);

    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async => initialSavedTracksPagingResponse);
        when(mockSpotifyRepository.removeFromLibrary(any))
            .thenAnswer((_) async => false);
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(SavedTracksFetch())
          ..add(SavedTracksRemoveTrackFromLibrary(
            track: initialSavedTracksPagingResponse.tracks[0].track,
          ));
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: finalSavedTracksPagingResponse,
          removedTrackFromLibrary: true,
        )
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async => initialSavedTracksPagingResponse);
        when(mockSpotifyRepository.removeFromLibrary(any))
            .thenThrow(Exception());
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(SavedTracksFetch())
          ..add(SavedTracksRemoveTrackFromLibrary(
            track: initialSavedTracksPagingResponse.tracks[0].track,
          ));
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
        SavedTracksState(
          status: TracksStatus.Success,
          removedTrackFromLibrary: false,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
      ],
    );
  });

  group('Reset saved tracks', () {
    SavedTracksPagingResponse initialSavedTracksPagingResponse =
        randomSavedTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenAnswer((_) async => initialSavedTracksPagingResponse);
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(SavedTracksFetch())..add(SavedTracksReset());
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
        SavedTracksState(
          status: TracksStatus.Initial,
          savedTracksPagingResponse: SavedTracksPagingResponse(),
        ),
        SavedTracksState(
          status: TracksStatus.Success,
          savedTracksPagingResponse: initialSavedTracksPagingResponse,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserSavedTracks())
            .thenThrow(Exception());
        return SavedTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(SavedTracksFetch())..add(SavedTracksReset());
      },
      expect: () => [
        SavedTracksState(
          status: TracksStatus.Failure,
        ),
        SavedTracksState(
          status: TracksStatus.Initial,
          savedTracksPagingResponse: SavedTracksPagingResponse(),
        ),
        SavedTracksState(
          status: TracksStatus.Failure,
          savedTracksPagingResponse: SavedTracksPagingResponse(),
        ),
      ],
    );
  });
}
