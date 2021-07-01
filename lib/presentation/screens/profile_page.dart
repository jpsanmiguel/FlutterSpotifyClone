import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/aws/ModelProvider.dart';
import 'package:spotify_clone/logic/bloc/profile/profile_bloc.dart';
import 'package:spotify_clone/presentation/widgets/list_tile_with_icons.dart';
import 'package:spotify_clone/constants/strings.dart' as Strings;

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            if (state.email != null) {
              return ListTileWithIcons(
                title: Strings.email,
                subtitle: state.email,
                leadingIcon: Icon(Icons.email),
                trailingIcon: Icon(Icons.edit),
                editingIcon: Icon(Icons.save),
                saveFunction: saveEmail,
                onChangedFunction: onChangedEmail,
                validateFunction: validateEmail,
                enabled: false,
              );
            }
            return Container();
          },
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.username != null) {
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
          UsernameSaved(username: state.username),
        );
  }

  onChangedEmail(BuildContext context, String email) {
    context.read<ProfileBloc>().add(
          EmailChanged(email: email),
        );
  }

  String validateEmail(ProfileState state, String email) {
    return state.validateEmail(email);
  }

  saveEmail(BuildContext context, ProfileState state) {
    context.read<ProfileBloc>().add(
          EmailSaved(email: state.email),
        );
  }
}
