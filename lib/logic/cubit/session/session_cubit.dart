import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/auth_repository.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  SessionCubit({@required this.authRepository}) : super(UnkownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepository.attemptAutoLogin();
    } on Exception {
      emit(UnautheticatedSessionState());
    }
  }

  void showAuth() => emit(UnautheticatedSessionState());
  void showSession(AuthCredentials authCredentials) {
    emit(
      AuthenticatedSessionState(
        user: authCredentials.email,
      ),
    );
  }

  void signOut() {
    authRepository.signOut();
    emit(UnautheticatedSessionState());
  }
}
