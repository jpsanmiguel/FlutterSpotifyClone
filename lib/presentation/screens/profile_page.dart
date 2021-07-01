import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/aws/ModelProvider.dart';
import 'package:spotify_clone/presentation/widgets/list_tile_with_icons.dart';
import 'package:spotify_clone/constants/strings.dart' as Strings;

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({
    Key key,
    @required this.user,
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
        ListTileWithIcons(
          title: Strings.user,
          subtitle: user.username,
          leadingIcon: Icon(Icons.person),
          trailingIcon: Icon(Icons.edit),
          editingIcon: Icon(Icons.save),
        ),
        ListTileWithIcons(
          title: Strings.email,
          subtitle: user.email,
          leadingIcon: Icon(Icons.email),
          trailingIcon: Icon(Icons.edit),
          editingIcon: Icon(Icons.save),
        ),
      ],
    );
  }
}
