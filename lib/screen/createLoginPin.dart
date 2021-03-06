import 'dart:convert';

import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:just_appoint/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiCall.dart';
import 'pinLogin.dart';

class CreateLoginPin extends StatefulWidget {
  String verifiedMobileNo;
  CreateLoginPin(this.verifiedMobileNo);
  @override
  _CreateLoginPinState createState() =>
      _CreateLoginPinState(this.verifiedMobileNo);
}

class _CreateLoginPinState extends State<CreateLoginPin> {
  String verifiedMobileNo;
  _CreateLoginPinState(this.verifiedMobileNo);
  TextEditingController pinOne = new TextEditingController();
  TextEditingController pinTwo = new TextEditingController();
  TextEditingController pinThree = new TextEditingController();
  TextEditingController pinFour = new TextEditingController();
  bool isButtonClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Login Pin"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
             margin: EdgeInsets.only(bottom: 20),
             child: Text(
                          "Create Your Login PIN",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
           ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      controller: pinOne,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      //obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("^[0-9]")),
                      ],
                      onChanged: (value) {
                        if (!value.isEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      controller: pinTwo,
                      textAlign: TextAlign.center,
                      // obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("^[0-9]")),
                      ],
                      onChanged: (value) {
                        if (!value.isEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      controller: pinThree,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      // obscureText: true,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("^[0-9]")),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: pinFour,
                    keyboardType: TextInputType.number,
                    //obscureText: true,
                    inputFormatters: [
                      new FilteringTextInputFormatter.allow(RegExp("^[0-9]")),
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                child: Text("Register"),
                onPressed: isButtonClicked
                    ? null
                    : () {
                        if (pinOne.text.isNotEmpty &&
                            pinTwo.text.isNotEmpty &&
                            pinThree.text.isNotEmpty &&
                            pinFour.text.isNotEmpty) {
                          setState(() {
                            isButtonClicked = true;
                          });
                          String pin = pinOne.text +
                              "" +
                              pinTwo.text +
                              "" +
                              pinThree.text +
                              "" +
                              pinFour.text;
                          registerMobileNo(pin);
                        }
                      },
              ),
            ),
            isButtonClicked
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Spinner(),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  registerMobileNo(String pin) async {
    ApiCall objApi = new ApiCall();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userType = "";
    if (sharedPreferences.getBool("isdoc")) {
      userType = "D";
    } else if (sharedPreferences.getBool("ispat")) {
      userType = "P";
    }
    final jsonData = {
      "mobile_no": this.verifiedMobileNo,
      "pin": pin,
      "user_type": userType
    };
    Map<String, String> requestHeaders = {};

    try {
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      String url = "common/registerMobile.php";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        setState(() {
          isButtonClicked = false;
        });
        var decodedJson = jsonDecode(status.body);
        if (decodedJson['status'] == 1) {
          String msg = "Registration Successfull.";
          showAlertDialog(context, msg);
        } else {
          String msg = "Registration Failed.";
          showAlertDialog(context, msg);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showAlertDialog(BuildContext context, String msg) {
    // set up the buttons

    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, SlideRightRoute(page: PinLogin()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(msg),
      actions: [okButton],
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
}
