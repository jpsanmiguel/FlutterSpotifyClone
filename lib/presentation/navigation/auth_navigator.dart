import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';
import 'package:spotify_clone/presentation/screens/confirmation_page.dart';
import 'package:spotify_clone/presentation/screens/login_page.dart';
import 'package:spotify_clone/presentation/screens/sign_up_page.dart';

class AuthNavigator extends StatelessWidget {
  final AuthRepository authRepository;

  const AuthNavigator({
    Key key,
    @required this.authRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is LoggedInAuthState) {
          context.read<AuthSessionCubit>().showSession(state.authCredentials);
        }
        return Navigator(
          pages: [
            if (state is LoginAuthState)
              MaterialPage(
                child: LoginPage(),
              ),
            if (state is SignUpAuthState ||
                state is ConfirmSignUpAuthState) ...[
              MaterialPage(child: SignUpPage()),
              if (state is ConfirmSignUpAuthState)
                MaterialPage(
                  child: ConfirmationPage(),
                ),
            ]
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}
