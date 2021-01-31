import 'package:flutter/material.dart';
import 'screen/splash.dart';

void main() {
  runApp(JustAppoint());
}
class JustAppoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      theme: ThemeData(
  primarySwatch: Colors.teal,
 primaryColor: Color(0xff08838B),
  primaryIconTheme: IconThemeData(
    color: Colors.white
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white
    )
  )
),
debugShowCheckedModeBanner: false,
home: SplashScreen()
    );
  }
}