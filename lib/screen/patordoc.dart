import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/screen/pinLogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientDocSelection extends StatelessWidget {
  SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color(0xff08838B),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: screenHeight * 0.4 / 5,
                width: screenWidth * 0.4,
                child: RaisedButton(
                  elevation: 7.0,
                  onPressed: () {
                    createUserType("doc");
                    Navigator.pushReplacement(
                        context, SlideRightRoute(page: PinLogin()));
                  },
                  child: Text(
                    "I'm Doctor",
                    style: TextStyle(fontSize: 18, color: Color(0xff08838B)),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.1 / 2,
              ),
              Container(
                height: screenHeight * 0.4 / 5,
                width: screenWidth * 0.4,
                child: RaisedButton(
                  elevation: 7.0,
                  onPressed: () {
                     createUserType("pat");
                      Navigator.pushReplacement(
                        context, SlideRightRoute(page: PinLogin()));
                  },
                  child: Text(
                    "I'm Patient",
                    style: TextStyle(fontSize: 18, color: Color(0xff08838B)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  createUserType(String usrType) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (usrType == "doc") {
      sharedPreferences.setBool("isdoc", true);
      sharedPreferences.setBool("ispat", false);
    } else if (usrType == "pat") {
      sharedPreferences.setBool("isdoc", false);
      sharedPreferences.setBool("ispat", true);
      
    }
  }
}
