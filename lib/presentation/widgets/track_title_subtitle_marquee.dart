import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/constants/strings.dart' as strings;

class TrackTitleSubtitleMarquee extends StatelessWidget {
  final bool loading;
  final String title;
  final String subtitle;

  const TrackTitleSubtitleMarquee({
    Key key,
    @required this.loading,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleTextSize = 16.0;
    final artistsTextSize = 14.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              loading ? strings.loading : title,
              textAlign: TextAlign.left,
              minFontSize: titleTextSize,
              style: TextStyle(
                fontSize: titleTextSize,
                color: textColor,
              ),
              // overflow: TextOverflow.ellipsis,
              overflowReplacement: Marquee(
                fadingEdgeEndFraction: 0.1,
                showFadingOnlyWhenScrolling: false,
                text: loading ? strings.loading : title,
                style: TextStyle(
                  fontSize: titleTextSize,
                  color: textColor,
                ),
                scrollAxis: Axis.horizontal,
                velocity: 45.0,
                blankSpace: 60.0,
                startAfter: Duration(seconds: 2),
                pauseAfterRound: Duration(seconds: 5),
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              loading ? strings.loading : subtitle,
              textAlign: TextAlign.left,
              minFontSize: artistsTextSize,
              style: TextStyle(
                fontSize: artistsTextSize,
                color: textColor.shade900,
              ),
              // overflow: TextOverflow.ellipsis,
              overflowReplacement: Marquee(
                fadingEdgeEndFraction: 0.1,
                showFadingOnlyWhenScrolling: false,
                text: loading ? strings.loading : subtitle,
                style: TextStyle(
                  fontSize: artistsTextSize,
                  color: textColor.shade900,
                ),
                scrollAxis: Axis.horizontal,
                velocity: 45.0,
                blankSpace: 60.0,
                startAfter: Duration(seconds: 2),
                pauseAfterRound: Duration(seconds: 5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
