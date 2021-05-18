import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';
import 'package:spotify_clone/logic/cubit/session/session_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;
  AuthCubit({
    @required this.sessionCubit,
  }) : super(LoginAuthState());

  AuthCredentials credentials;

  void showLogin() => emit(LoginAuthState());

  void showSignUp() => emit(SignUpAuthState());

  void showConfirmSignUp({
    String username,
    String email,
    String password,
  }) {
    credentials = AuthCredentials(
      username: username,
      email: email,
      password: password,
    );
    emit(ConfirmSignUpAuthState());
  }

  void launchSession(AuthCredentials authCredentials) {
    sessionCubit.showSession(authCredentials);
  }
}
