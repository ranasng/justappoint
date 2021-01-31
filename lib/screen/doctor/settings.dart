import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 10,),
      child: ListView(
        children: [
          FlatButton(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.exit_to_app),
                  Text("Logout",
                  style: TextStyle(fontSize: 18),
                  ),

                ],
              ),
            ),
            textColor: Colors.white,
            onPressed: () {
              logOut();
            },
          )
        ],
      ),
    );
  }

  logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }
}
