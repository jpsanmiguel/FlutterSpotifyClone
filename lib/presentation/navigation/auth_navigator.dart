import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/auth_repository.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/presentation/screens/login_page.dart';
import 'package:spotify_clone/presentation/screens/register_page.dart';

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
        return Navigator(
          pages: [
            if (state is LoginAuthState)
              MaterialPage(
                child: LoginPage(
                  authRepository: authRepository,
                ),
              ),
            if (state is SignUpAuthState)
              MaterialPage(
                child: RegisterPage(
                  authRepository: authRepository,
                ),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}
