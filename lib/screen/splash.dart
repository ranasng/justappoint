import 'dart:convert';
import 'dart:io';

import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/apiCall.dart';
import 'package:just_appoint/screen/patordoc.dart';
import 'package:just_appoint/screen/pinLogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'doctor/docHome.dart';
import 'doctorprofile/basicdtls.dart';
import 'patient/patHome.dart';
import 'patient/patProfileCreate.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  bool versionStatus = false;
  @override
  void initState() {
    checkVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenwidth,
        color: Color(0xff08838B),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight / 4,
              width: screenwidth / 2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo1.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            /* FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Just Appoint",
                  style: GoogleFonts.dmSans(
                      textStyle: TextStyle(fontSize: 45, color: Colors.white))),
            ), */
            /*  Container(
              margin: EdgeInsets.only(top:15),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("Online Doctor's Appointment",
                    style: GoogleFonts.courgette(
                        textStyle: TextStyle(fontSize: 25, color: Colors.white))),
              ),
            ) */
          ],
        ),
      ),
    );
  }

  checkIslogged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getBool("isLogged")) {
        if (sharedPreferences.getBool("isdoc")) {
          if (sharedPreferences.getBool("isProfile")) {
            Navigator.pushReplacement(
                context, SlideRightRoute(page: DoctorHomePage()));
          } else {
            Navigator.pushReplacement(
                context, SlideRightRoute(page: BasicDetails()));
          }
        } else {
          if (sharedPreferences.getBool("isProfile")) {
            Navigator.pushReplacement(
                context, SlideRightRoute(page: PatientHomePage()));
          } else {
            Navigator.pushReplacement(
                context, SlideRightRoute(page: PatProfileCreate()));
          }
        }
      } else {
        Navigator.pushReplacement(context, SlideRightRoute(page: PinLogin()));
        // Navigator.pushReplacement(context, SlideRightRoute(page: RegisterMobileNo()));
      }
    } on SocketException catch (e) {} catch (e) {
      sharedPreferences.clear();
      // Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, SlideRightRoute(page: PatientDocSelection()));
      // });
    }
  }

  checkVersion() async {
    Map<String, String> requestHeaders = {};
    ApiCall objApi = new ApiCall();
    try {
      String url = "version.php";
      final status = await objApi.callGetMethod(url, requestHeaders);
      if (status.statusCode == 200) {
        if (status.body != "") {
          var responseBody = jsonDecode(status.body);
          if (responseBody['status'] == 1) {
            if (ApiCall.versionNo == responseBody['version']) {
              versionStatus = true;
              checkIslogged();
            } else {
              showAlertDialog(context, responseBody['force_update']);
            }
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showAlertDialog(BuildContext context, int forceUpdate) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Skip"),
      onPressed: () {
        checkIslogged();
        Navigator.of(context).pop();
      },
    );
    Widget okButton = FlatButton(
      child: Text("Download"),
      onPressed: () {
        Navigator.of(context).pop();
        _launchURL('https://play.google.com/store/apps/details?id=com.codeeko.just_appoint');
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("New Version is available Please Update."),
      actions: [okButton, forceUpdate == 0 ? cancelButton : SizedBox()],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
