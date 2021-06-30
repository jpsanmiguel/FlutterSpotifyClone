import 'package:flutter/material.dart';
import 'package:spotify_clone/data/models/track.dart';
import 'package:spotify_clone/presentation/widgets/track_title_subtitle_marquee.dart';

class TrackWidget extends StatelessWidget {
  final Track track;
  final MaterialColor backgroundColor;
  final IconData icon;
  final MaterialColor iconColor;
  final Function onItemPressed;
  final Function onIconPressed;
  final bool loading;
  final bool isPlaying;
  final bool errorPlaying;

  const TrackWidget({
    Key key,
    this.track,
    @required this.backgroundColor,
    this.icon,
    this.iconColor,
    this.onItemPressed,
    this.onIconPressed,
    this.loading,
    this.isPlaying,
    this.errorPlaying,
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
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    flex: 1,
                    child: Image.network(
                      track.getImageUrl(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
            track != null
                ? Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TrackTitleSubtitleMarquee(
                        loading: loading,
                        title: track.name,
                        subtitle: track.getArtistsNames(),
                      ),
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
