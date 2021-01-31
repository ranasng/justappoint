import 'dart:convert';

import 'package:just_appoint/animate/slideRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_appoint/tokenManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiCall.dart';
import '../changePin.dart';
import '../registerMobile.dart';
import 'doctor/docHome.dart';
import 'doctor/widget/spinner.dart';
import 'doctorprofile/basicdtls.dart';
import 'patient/patHome.dart';
import 'patient/patProfileCreate.dart';

class PinLogin extends StatefulWidget {
  @override
  _PinLoginState createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> {
  @override
  void initState() {
    super.initState();
  }

  var genOtpFormKey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();
  bool isButtonclicked = false;
  ApiCall objApi = new ApiCall();
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: mScaffoldState,
      appBar: AppBar(
        title: Text("Just Appoint"),
      ),
      body: Container(
        //padding: EdgeInsets.fromLTRB(10, screenHeight*.2, 10, screenHeight*.1/2),
        // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                /* Text(
                  "Covid-19 Care",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 1.5
                  ),
                ) ,*/
                SizedBox(
                  height: screenHeight * .1 / 6,
                ),
                Card(
                  elevation: 4,
                  child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                          key: genOtpFormKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: mobileNoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  new FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "Please Enter 10 Digit Mobile No";
                                  }
                                  if (value.length != 10) {
                                    return "Only 10 digit no you can enter";
                                  }
                                },
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    labelText: '10 Digit Mobile No',
                                    prefixIcon: Icon(Icons.phone_android),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: pinController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  new FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "Please Enter 4 Digit Login Pin";
                                  }
                                  if (value.length != 4) {
                                    return "Only 4 digit no you can enter";
                                  }
                                },
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    labelText: 'Login Pin',
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: FlatButton(
                                  disabledColor: Colors.grey,
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Login',
                                  ),
                                  onPressed: isButtonclicked
                                      ? null
                                      : () {
                                        FocusScope.of(context).unfocus();
                                          setState(() {
                                            if (genOtpFormKey.currentState
                                                .validate()) {
                                              isButtonclicked = true;
                                              pinLogin(
                                                  mobileNoController.text,
                                                  pinController.text,
                                                  screenHeight);
                                            }
                                          });
                                        },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: isButtonclicked
                                    ? Spinner()
                                    : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            child: Text(
                                              "Forgot PIN?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blueAccent),
                                            ),
                                            onTap: () {                                              
                                              Navigator.push(
                                                  context,
                                                  SlideRightRoute(
                                                      page: ChangePin()));
                                            },
                                          ),
                                        InkWell(
                                            child: Text(
                                              "Register",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blueAccent),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  SlideRightRoute(
                                                      page: RegisterMobileNo()));
                                            },
                                          ),
                                      ],
                                    ),
                              )
                            ],
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pinLogin(String mobileNo, String pin, var height) async {
    Map<String, String> requestHeaders = {};
    // print(jsonEncode(jsonData));
    TokenManager objToken = new TokenManager();
    String userType = "";
    try {
      String url = "common/pinLogin.php";
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getBool("isdoc")) {
        userType = "D";
      } else if (sharedPreferences.getBool("ispat")) {
        userType = "P";
      }
      final jsonData = {
        "mobile": mobileNo,
        "login_pin": pin,
        "user_type": userType
      };
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      //String encodedStr = "";
      bool isProfile = false, isLogged = false;
      String userId = "0", mobileNoRcv = "0", emailId = "";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        if (status.body != "") {
          print(status.body);
          var responseBody = jsonDecode(status.body);
          setState(() {
            isButtonclicked = false;
          });
          if (responseBody['loginStatus'] == 1) {
            isLogged = true;
            objToken.createLoginSession(isLogged, responseBody['token']);            
          }
          if (responseBody['loginStatus'] == 1 &&
              responseBody['profileStatus'] == 1) {
            isProfile = true;
            objToken.setProfileSession(isProfile,responseBody['first_name']);
            objToken.setEmailSession(responseBody['email_id']);
            objToken.setDefaultClinicSession(responseBody['default_clinic_id']);
            Navigator.of(context).popUntil((route) => route.isFirst);
            if (userType == "D") {
              Navigator.pushReplacement(
                  context, SlideRightRoute(page: DoctorHomePage()));
            } else {
              Navigator.pushReplacement(
                  context, SlideRightRoute(page: PatientHomePage()));
            }
          } else if (responseBody['loginStatus'] == 1 &&
              responseBody['profileStatus'] == 0) {
            isProfile = false;           
                objToken.setProfileSession(isProfile,"");
            Navigator.of(context).popUntil((route) => route.isFirst);
            if (userType == "D") {
              Navigator.pushReplacement(
                  context, SlideRightRoute(page: BasicDetails()));
            } else {
              Navigator.pushReplacement(
                  context, SlideRightRoute(page: PatProfileCreate()));
            }
          } else {
            showSnackBar('Mobile Number/PIN Mismatch', height);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void showSnackBar(String msg, var height) {
    final snackBar = new SnackBar(
      content: new Container(
          height: height / 11,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            msg,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      duration: Duration(minutes: 20),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
    mScaffoldState.currentState.showSnackBar(snackBar);
  }

}
