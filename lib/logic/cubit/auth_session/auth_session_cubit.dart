import 'package:amplify_api/amplify_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/data/models/aws/ModelProvider.dart';

part 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  final AuthRepository authRepository;
  final DataRepository dataRepository;

  AuthSessionCubit({
    @required this.authRepository,
    @required this.dataRepository,
  }) : super(UnkownSessionState());

  void attemptAutoLogin() async {
    try {
      final userId = await authRepository.attemptAutoLogin();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      User user = await dataRepository.getUserById(userId);
      if (user == null) {
        user = await dataRepository.createUser(
          userId: userId,
          username: 'User-${UUID()}',
        );
      }
      emit(AuthenticatedSessionState(user: user));
    } on Exception {
      emit(UnauthenticatedSessionState());
    }
  }

  void showAuth() => emit(UnauthenticatedSessionState());

  void showSession(AuthCredentials authCredentials) async {
    try {
      User user = await dataRepository.getUserById(authCredentials.userId);

      if (user == null) {
        user = await dataRepository.createUser(
          userId: authCredentials.userId,
          email: authCredentials.email,
          username: authCredentials.username,
        );
      }

      emit(
        AuthenticatedSessionState(
          user: user,
        ),
      );
    } catch (e) {
      emit(UnauthenticatedSessionState());
    }
  }

  void signOut() {
    authRepository.signOut();
    emit(UnauthenticatedSessionState());
  }
}
