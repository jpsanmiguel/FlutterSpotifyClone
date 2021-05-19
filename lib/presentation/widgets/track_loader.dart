import 'package:flutter/material.dart';

class TrackLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height: 36,
          width: 36,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
