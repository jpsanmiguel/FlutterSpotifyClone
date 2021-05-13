import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final MaterialColor backgroundColor;
  final IconData icon;
  final MaterialColor iconColor;
  final Function onItemPressed;
  final Function onIconPressed;

  const TrackWidget(
      {Key key,
      @required this.track,
      @required this.backgroundColor,
      @required this.icon,
      @required this.iconColor,
      this.onItemPressed,
      this.onIconPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.network('${track.getImageUrl()}'),
        title: Text(
          track.name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          track.getArtistsNames(),
          style: TextStyle(
            color: textColor,
          ),
        ),
        trailing: InkWell(
          child: Icon(
            icon,
            color: iconColor,
          ),
          onTap: () async {
            onIconPressed != null
                ? onIconPressed(track)
                : print('Nothing to do in icon!');
          },
        ),
        onTap: () async {
          onItemPressed != null
              ? onItemPressed(track)
              : print('Nothing to do!');
        },
      ),
    );
  }
}
