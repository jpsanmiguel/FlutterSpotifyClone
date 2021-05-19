import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/repositories/auth_repository.dart';
import 'package:spotify_clone/data/repositories/spotify_repository.dart';
import 'package:spotify_clone/logic/cubit/auth/auth_cubit.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';
import 'package:spotify_clone/presentation/navigation/auth_navigator.dart';
import 'package:spotify_clone/presentation/navigation/router/bottom_router.dart';
import 'package:spotify_clone/presentation/screens/home_page.dart';
import 'package:spotify_clone/presentation/screens/splash_page.dart';

class AppNavigator extends StatelessWidget {
  final SpotifyRepository spotifyRepository;
  const AppNavigator({
    Key key,
    @required this.spotifyRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionCubit, AuthSessionState>(
      builder: (context, state) {
        return Navigator(
          pages: [
            if (state is UnkownSessionState) MaterialPage(child: SplashPage()),
            if (state is UnautheticatedSessionState)
              MaterialPage(
                child: BlocProvider(
                  create: (context) =>
                      AuthCubit(sessionCubit: context.read<AuthSessionCubit>()),
                  child: AuthNavigator(
                    authRepository: context.read<AuthRepository>(),
                  ),
                ),
              ),
            if (state is AuthenticatedSessionState)
              MaterialPage(
                child: HomePage(
                  user: state.user,
                  bottomRouter: BottomRouter(
                    spotifyRepository: spotifyRepository,
                    authRepository: context.read<AuthRepository>(),
                  ),
                ),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}
