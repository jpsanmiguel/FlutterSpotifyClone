import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/presentation/widgets/track_title_subtitle_marquee.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final MaterialColor backgroundColor;
  final IconData icon;
  final MaterialColor iconColor;
  final Function onItemPressed;
  final Function onIconPressed;
  final Function addToLibrary;
  final Function removeFromLibrary;
  final bool loading;
  final bool errorPlaying;
  final bool isPlayer;

  const TrackWidget({
    Key key,
    this.track,
    @required this.backgroundColor,
    this.icon,
    this.iconColor,
    this.onItemPressed,
    this.onIconPressed,
    this.addToLibrary,
    this.removeFromLibrary,
    this.loading,
    this.errorPlaying,
    this.isPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onItemPressed != null) onItemPressed(track);
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: 60.0,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Row(
          children: [
            loading || track == null
                ? SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    flex: 1,
                    child: Image.network(
                      "${track.getImageUrl()}",
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: TrackTitleSubtitleMarquee(
                  loading: loading,
                  title: track != null ? track.name : "",
                  subtitle: track != null ? track.getArtistsNames() : "",
                ),
              ),
            ),
            isPlayer
                ? Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        track.inLibrary
                            ? removeFromLibrary(track)
                            : addToLibrary(track);
                      },
                      child: track != null
                          ? Icon(
                              track.inLibrary
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: greenColor,
                            )
                          : Container(),
                    ),
                  )
                : Container(),
            !errorPlaying
                ? Expanded(
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
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
