import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/data/models/auth_credentials.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthCredentials credentials;

  void showLogin() => emit(LoginAuthState());

  void showSignUp() => emit(SignUpAuthState());

  void launchSession(AuthCredentials authCredentials) =>
      emit(LoggedInAuthState(authCredentials: authCredentials));

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
}
