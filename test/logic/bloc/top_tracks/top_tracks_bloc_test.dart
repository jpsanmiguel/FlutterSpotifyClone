import 'package:bloc_test/bloc_test.dart' as blocTest;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify_clone/constants/enums.dart';
import 'package:spotify_clone/data/response/top_tracks_paging_response.dart';
import 'package:spotify_clone/logic/bloc/top_tracks/top_tracks_bloc.dart';

import '../../../mocks/mock_spotify_repository.dart';
import '../../../utils.dart';

void main() {
  MockSpotifyRepository mockSpotifyRepository;

  setUp(() {
    mockSpotifyRepository = MockSpotifyRepository();
  });

  group('Request initial tracks with more to load', () {
    final topTracksPagingResponse = randomTopTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: false,
    );

    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks())
            .thenAnswer((_) async => topTracksPagingResponse);
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: topTracksPagingResponse,
          hasReachedEnd: false,
        )
      ],
    );
    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenThrow(Exception());
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Failure,
        ),
      ],
    );
  });

  group('Request initial tracks without more to load', () {
    final topTracksPagingResponse = randomTopTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: true,
      isInitial: true,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenAnswer((_) async {
          return topTracksPagingResponse;
        });
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: topTracksPagingResponse,
          hasReachedEnd: true,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenThrow(Exception());
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Failure,
        ),
      ],
    );
  });

  group('Request more tracks', () {
    TopTracksPagingResponse initialTopTracksPagingResponse =
        randomTopTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    TopTracksPagingResponse moreTopTracksPagingResponse =
        randomTopTracksPagingResponseWithNTracks(
      size: 3,
      isFinal: false,
      isInitial: false,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenAnswer((_) async {
          return initialTopTracksPagingResponse;
        });
        when(mockSpotifyRepository.fetchMoreUserTopTracks(
          nextUrl: anyNamed('nextUrl'),
        )).thenAnswer((_) async {
          return moreTopTracksPagingResponse;
        });
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch())..add(TopTracksFetch());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
          hasReachedEnd: false,
        ),
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: moreTopTracksPagingResponse,
          hasReachedEnd: false,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenAnswer((_) async {
          return initialTopTracksPagingResponse;
        });
        when(mockSpotifyRepository.fetchMoreUserTopTracks(
          nextUrl: anyNamed('nextUrl'),
        )).thenThrow(Exception());
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch())..add(TopTracksFetch());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
          hasReachedEnd: false,
        ),
        TopTracksState(
          status: TracksStatus.Failure,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
      ],
    );
  });

  group('Add track to library', () {
    TopTracksPagingResponse initialTopTracksPagingResponse =
        randomTopTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: false,
    );
    final finalTopTracksPagingResponse =
        initialTopTracksPagingResponse.copyWith();
    finalTopTracksPagingResponse.tracks[0].inLibrary = true;
    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenAnswer((_) async {
          return initialTopTracksPagingResponse;
        });
        when(mockSpotifyRepository.addToLibrary(
          any,
        )).thenAnswer((_) async => true);
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(TopTracksFetch())
          ..add(TopTracksAddTrackToLibrary(
            track: initialTopTracksPagingResponse.tracks[0],
          ));
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
          isAddingTrackToLibrary: true,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenAnswer((_) async {
          return initialTopTracksPagingResponse;
        });
        when(mockSpotifyRepository.addToLibrary(any)).thenThrow(Exception());
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(TopTracksFetch())
          ..add(TopTracksAddTrackToLibrary(
            track: initialTopTracksPagingResponse.tracks[0],
          ));
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
          isAddingTrackToLibrary: false,
        ),
      ],
    );
  });

  group('Remove track from library', () {
    TopTracksPagingResponse initialTopTracksPagingResponse =
        randomTopTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    final finalTopTracksPagingResponse =
        initialTopTracksPagingResponse.copyWith();
    finalTopTracksPagingResponse.tracks =
        initialTopTracksPagingResponse.tracks.sublist(1);

    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks())
            .thenAnswer((_) async => initialTopTracksPagingResponse);
        when(mockSpotifyRepository.removeFromLibrary(any))
            .thenAnswer((_) async => false);
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(TopTracksFetch())
          ..add(TopTracksRemoveTrackFromLibrary(
            track: initialTopTracksPagingResponse.tracks[0],
          ));
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: finalTopTracksPagingResponse,
          isRemovingTrackFromLibrary: true,
        )
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks())
            .thenAnswer((_) async => initialTopTracksPagingResponse);
        when(mockSpotifyRepository.removeFromLibrary(any))
            .thenThrow(Exception());
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc
          ..add(TopTracksFetch())
          ..add(TopTracksRemoveTrackFromLibrary(
            track: initialTopTracksPagingResponse.tracks[0],
          ));
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
        TopTracksState(
          status: TracksStatus.Success,
          isRemovingTrackFromLibrary: false,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
      ],
    );
  });

  group('Reset top tracks', () {
    TopTracksPagingResponse initialTopTracksPagingResponse =
        randomTopTracksPagingResponseWithNTracks(
      size: 2,
      isFinal: false,
      isInitial: true,
      tracksInLibrary: true,
    );
    blocTest.blocTest(
      'Success',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks())
            .thenAnswer((_) async => initialTopTracksPagingResponse);
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch())..add(TopTracksReset());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
        TopTracksState(
          status: TracksStatus.Initial,
          topTracksPagingResponse: TopTracksPagingResponse(),
        ),
        TopTracksState(
          status: TracksStatus.Success,
          topTracksPagingResponse: initialTopTracksPagingResponse,
        ),
      ],
    );

    blocTest.blocTest(
      'Failure',
      build: () {
        when(mockSpotifyRepository.fetchUserTopTracks()).thenThrow(Exception());
        return TopTracksBloc(spotifyRepository: mockSpotifyRepository);
      },
      act: (bloc) {
        bloc..add(TopTracksFetch())..add(TopTracksReset());
      },
      expect: () => [
        TopTracksState(
          status: TracksStatus.Failure,
        ),
        TopTracksState(
          status: TracksStatus.Initial,
          topTracksPagingResponse: TopTracksPagingResponse(),
        ),
        TopTracksState(
          status: TracksStatus.Failure,
          topTracksPagingResponse: TopTracksPagingResponse(),
        ),
      ],
    );
  });
}
