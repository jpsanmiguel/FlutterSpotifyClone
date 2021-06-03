import 'package:bloc_test/bloc_test.dart' as blocTest;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/data/models/aws/ModelProvider.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';

import '../../../mocks/mock_auth_repository.dart';
import '../../../mocks/mock_data_repository.dart';

void main() {
  group('AuthSessionCubit', () {
    MockAuthRepository mockAuthRepository;
    MockDataRepository mockDataRepository;
    User user;
    AuthCredentials authCredentials;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockDataRepository = MockDataRepository();
      user = User();
      authCredentials = AuthCredentials(
        email: '',
        password: '',
        userId: '',
        username: '',
      );
    });

    test('Initial state of AuthSessionCubit is UnkownSessionState', () {
      expect(
          AuthSessionCubit(
            authRepository: mockAuthRepository,
            dataRepository: mockDataRepository,
          ).state,
          UnkownSessionState());
    });

    blocTest.blocTest(
      'Should emit AuthenticatedSessionState when attemptAutoLogin function is called succesfully',
      build: () {
        when(mockAuthRepository.attemptAutoLogin())
            .thenAnswer((_) async => '123456');
        when(mockDataRepository.getUserById(any)).thenAnswer((_) async => user);
        when(mockDataRepository.createUser()).thenAnswer((_) async => user);
        return AuthSessionCubit(
          authRepository: mockAuthRepository,
          dataRepository: mockDataRepository,
        );
      },
      act: (cubit) => cubit.attemptAutoLogin(),
      expect: () => [AuthenticatedSessionState(user: user)],
    );

    blocTest.blocTest(
      'Should emit UnauthenticatedSessionState when attemptAutoLogin function is called unsuccesfully',
      build: () {
        when(mockAuthRepository.attemptAutoLogin())
            .thenAnswer((_) async => '123456');
        when(mockDataRepository.getUserById(any)).thenThrow(Exception());
        when(mockDataRepository.createUser()).thenThrow(Exception());
        return AuthSessionCubit(
          authRepository: mockAuthRepository,
          dataRepository: mockDataRepository,
        );
      },
      act: (cubit) => cubit.attemptAutoLogin(),
      expect: () => [UnauthenticatedSessionState()],
    );

    blocTest.blocTest(
      'Should emit UnauthenticatedSessionState when showAuth function is called',
      build: () => AuthSessionCubit(
        authRepository: mockAuthRepository,
        dataRepository: mockDataRepository,
      ),
      act: (cubit) => cubit.showAuth(),
      expect: () => [UnauthenticatedSessionState()],
    );

    blocTest.blocTest(
      'Should emit AuthenticatedSessionState when showSession function is called succesfully',
      build: () {
        when(mockAuthRepository.attemptAutoLogin())
            .thenAnswer((_) async => '123456');
        when(mockDataRepository.getUserById(any)).thenAnswer((_) async => user);
        when(mockDataRepository.createUser(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          username: anyNamed('username'),
        )).thenAnswer((_) async => user);
        return AuthSessionCubit(
          authRepository: mockAuthRepository,
          dataRepository: mockDataRepository,
        );
      },
      act: (cubit) => cubit.showSession(authCredentials),
      expect: () => [AuthenticatedSessionState(user: user)],
    );

    blocTest.blocTest(
      'Should emit AuthenticatedSessionState when showSession function is called unsuccesfully',
      build: () {
        when(mockAuthRepository.attemptAutoLogin())
            .thenAnswer((_) async => '123456');
        when(mockDataRepository.getUserById(any)).thenThrow(Exception());
        when(mockDataRepository.createUser()).thenThrow(Exception());
        return AuthSessionCubit(
          authRepository: mockAuthRepository,
          dataRepository: mockDataRepository,
        );
      },
      act: (cubit) => cubit.showSession(authCredentials),
      expect: () => [UnauthenticatedSessionState()],
    );

    blocTest.blocTest(
      'Should emit UnauthenticatedSessionState when signOut function is called succesfully',
      build: () {
        return AuthSessionCubit(
          authRepository: mockAuthRepository,
          dataRepository: mockDataRepository,
        );
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [UnauthenticatedSessionState()],
    );

    blocTest.blocTest(
      'Should emit AuthenticatedSessionState when signOut function is called unsuccesfully',
      build: () {
        when(mockAuthRepository.signOut()).thenThrow(Exception());
        return AuthSessionCubit(
          authRepository: mockAuthRepository,
          dataRepository: mockDataRepository,
        );
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [],
    );
  });
}
