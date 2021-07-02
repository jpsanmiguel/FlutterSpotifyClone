import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/repositories/data_repository.dart';
import 'package:spotify_clone/logic/bloc/profile/profile_bloc.dart';
import 'package:spotify_clone/logic/cubit/auth_session/auth_session_cubit.dart';
import 'package:spotify_clone/presentation/widgets/list_tile_with_icons.dart';
import 'package:spotify_clone/constants/strings.dart' as Strings;

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        dataRepository: context.read<DataRepository>(),
        user: context.read<AuthSessionCubit>().currentUser,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.contain,
                    height: 160.0,
                    width: 160.0,
                    imageUrl:
                        "https://noticieros.televisa.com/wp-content/uploads/2021/05/shakira-karol-g-reaccionan-a-lo-que-pasa-en-colombia.jpg",
                    imageBuilder: (context, imageProvider) {
                      print("something!");
                      // you can access to imageProvider
                      return CircleAvatar(
                        // or any widget that use imageProvider like (PhotoView)
                        backgroundImage: imageProvider,
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          print("Holi");
                        },
                        splashColor: darkGreyColor,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.user.email != null) {
                return ListTileWithIcons(
                  title: Strings.email,
                  subtitle: state.email,
                  leadingIcon: Icon(Icons.email),
                  trailingIcon: Icon(Icons.edit),
                  editingIcon: Icon(Icons.save),
                  enabled: false,
                );
              }
              return Container();
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.user.username != null) {
                return ListTileWithIcons(
                  title: Strings.user,
                  subtitle: state.username,
                  leadingIcon: Icon(Icons.person),
                  trailingIcon: Icon(Icons.edit),
                  editingIcon: Icon(Icons.save),
                  saveFunction: saveUsername,
                  onChangedFunction: onChangedUsername,
                  validateFunction: validateUsername,
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  onChangedUsername(BuildContext context, String username) {
    context.read<ProfileBloc>().add(
          UsernameChanged(username: username),
        );
  }

  String validateUsername(ProfileState state, String username) {
    return state.validateUsername(username);
  }

  saveUsername(BuildContext context, ProfileState state) {
    context.read<ProfileBloc>().add(
          SaveUsername(username: state.username),
        );
  }
}
