import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: CircularProgressIndicator(),
      child: Padding(
        padding: const EdgeInsets.all(104.0),
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
