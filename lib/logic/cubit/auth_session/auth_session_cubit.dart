import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/models/ModelProvider.dart';

part 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  final AuthRepository authRepository;
  final DataRepository dataRepository;

  User get currentUser => (state as AuthenticatedSessionState).user;

  Stream<SubscriptionEvent<User>> userStream =
      Amplify.DataStore.observe(User.classType);

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
      _subscribeToUserChanges();
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
      _subscribeToUserChanges();
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

  void _subscribeToUserChanges() {
    userStream.listen((event) {
      if (event.item.id == currentUser.id) {
        emit(AuthenticatedSessionState(user: event.item));
      }
    });
  }
}
