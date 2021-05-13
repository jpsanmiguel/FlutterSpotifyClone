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
  final bool loading;

  const TrackWidget(
      {Key key,
      this.track,
      @required this.backgroundColor,
      this.icon,
      this.iconColor,
      this.onItemPressed,
      this.onIconPressed,
      this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onItemPressed != null) onItemPressed(track);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
        child: Row(
          children: [
            loading
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    flex: 1,
                    child: Image.network(
                      track.getImageUrl(),
                    ),
                  ),
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        loading ? 'Cargando...' : track.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      loading ? 'Cargando...' : track.getArtistsNames(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: textColor.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (onIconPressed != null) onIconPressed(track);
                },
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     color: backgroundColor,
    //   ),
    //   child: ListTile(
    //     leading: Image.network('${track.getImageUrl()}'),
    //     title: Text(
    //       '${track.name}',
    //       style: TextStyle(
    //         color: textColor,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     subtitle: Text(
    //       '${track.getArtistsNames()}',
    //       style: TextStyle(
    //         color: textColor,
    //       ),
    //     ),
    //     trailing: InkWell(
    //       child: Icon(
    //         icon,
    //         color: iconColor,
    //       ),
    //       onTap: () async {
    //         onIconPressed != null
    //             ? onIconPressed(track)
    //             : print('Nothing to do in icon!');
    //       },
    //     ),
    //     onTap: () async {
    //       onItemPressed != null
    //           ? onItemPressed(track)
    //           : print('Nothing to do!');
    //     },
    //     isThreeLine: false,
    //     dense: true,
    //   ),
    // );
  }
}
