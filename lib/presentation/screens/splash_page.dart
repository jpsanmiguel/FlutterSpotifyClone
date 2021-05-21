import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(104.0),
        child: Image.asset(LOGO_URL),
      ),
    );
  }
}
