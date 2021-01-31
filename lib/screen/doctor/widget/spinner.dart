import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  Spinner();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                semanticsLabel: "Loading",
      ),
    );
  }
}