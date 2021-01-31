import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_appoint/screen/changeLoginPin.dart';

import 'animate/slideRouter.dart';
import 'apiCall.dart';
import 'screen/createLoginPin.dart';
import 'screen/doctor/widget/spinner.dart';

//createpin,updatepin
class VerifyMobile extends StatefulWidget {
  String title;
  String verificationType;
  @override
  _VerifyMobileState createState() => _VerifyMobileState();
  VerifyMobile({this.title, @required this.verificationType});
}

class _VerifyMobileState extends State<VerifyMobile> {
  final _phoneController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var regMobileFormkey = GlobalKey<FormState>();
  bool isotpSent = false;
  dynamic screenHeight;
  dynamic screenwidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(32),
        child: Form(
          key: regMobileFormkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${widget.title}",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey[300])),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "Mobile Number"),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter Mobile Number";
                  }
                  if (value.length > 10 || value.length < 10) {
                    return "Mobile Number Must be 10 digit";
                  }
                },
                controller: _phoneController,
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("Get OTP"),
                  disabledColor: Colors.grey,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(16),
                  onPressed: isotpSent
                      ? null
                      : () {
                          if (regMobileFormkey.currentState.validate()) {
                           FocusScope.of(context).unfocus();
                            setState(() {
                                  isotpSent = true;
                                });
                            checkIsmobileAvailable(
                                    _phoneController.text, context)
                                .then((value) {
                              if (value == 1 &&
                                  widget.verificationType == "createpin") {
                                showSnackBar(
                                    "Mobile Number Already Registered", 100);
                                setState(() {
                                  isotpSent = false;
                                });
                              } else if (value == 1 &&
                                  widget.verificationType == "updatepin") {
                                logoutFirebase();
                                sendOTP(_phoneController.text, context);
                              } else if (value == 0 &&
                                  widget.verificationType == "createpin") {
                                logoutFirebase();
                                sendOTP(_phoneController.text, context);
                              } else if (value == 0 &&
                                  widget.verificationType == "updatepin") {
                                showSnackBar(
                                    "Mobile Number Not Registered", 100);
                                setState(() {
                                  isotpSent = false;
                                });
                              }
                            });
                          }
                        },
                  color: Theme.of(context).primaryColor,
                ),
              ),
              isotpSent
                  ? Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Spinner(),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future sendOTP(String mobile, BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneController.text,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential result = await _auth.signInWithCredential(credential);
        User user = result.user;
        if (user != null) {
          showAlertDialogSuccess(context);
        } else {
          print("Error");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isotpSent = false;
        });
        showSnackBar("Error:" + e.code, 100);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        setState(() {
          isotpSent = false;
        });
        verificationPopup(verificationId, _auth);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;

        Navigator.of(context, rootNavigator: true).pop('dialog');
        showSnackBar("Timeout, Please try again later", 100);
      },
    );
  }

  Future<int> checkIsmobileAvailable(
      String mobileNo, BuildContext context) async {
    ApiCall objApi = new ApiCall();
    final jsonData = {"mobile_no": mobileNo};
    int mobileAvailable = 0;
    Map<String, String> requestHeaders = {};
    try {
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      String url = "common/checkMobileAvailable.php";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        //  debugPrint(status.body);
        var decodedJson = jsonDecode(status.body);
        if (decodedJson['mobile_available'] == "0") {
          mobileAvailable = 0;
        } else {
          mobileAvailable = 1;
          setState(() {
            isotpSent = false;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return mobileAvailable;
  }

  void showSnackBar(String msg, var height) {
    final snackBar = new SnackBar(
      content: new Container(
          child: Text(
        msg,
      )),
      duration: Duration(minutes: 20),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void verificationPopup(var verificationId, var _auth) async {
    String errorMsg = "";
    bool isCodeSubmitted = false;
    final _codeController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Enter Verification Code"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Row(
                    children: [
                      isCodeSubmitted ? Spinner() : Text("Verify OTP"),
                    ],
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: isCodeSubmitted
                      ? null
                      : () async {
                          setState(() {
                            isCodeSubmitted = true;
                          });

                          final code = _codeController.text.trim();
                          try {
                            AuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: code);
                            UserCredential result =
                                await _auth.signInWithCredential(credential);
                            User user = result.user;
                            if (user != null) {
                              if (widget.verificationType == "updatepin") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChangeLoginPin(
                                            _phoneController.text)));
                              } else if (widget.verificationType ==
                                  "createpin") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateLoginPin(
                                            _phoneController.text)));
                              }
                            } else {
                              setState(() {
                                errorMsg = "PIN Verification Failed";
                                isCodeSubmitted = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              errorMsg = "PIN Verification Failed";
                              isCodeSubmitted = false;
                            });
                          }
                        },
                )
              ],
            );
          });
        });
  }

  showAlertDialogSuccess(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        if (widget.verificationType == "updatepin") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeLoginPin(_phoneController.text)));
        } else if (widget.verificationType == "createpin") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateLoginPin(_phoneController.text)));
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Congratulations"),
      content: Container(
        height: screenHeight / 5,
        child: Column(
          children: [
            Container(
              child:
                  Icon(Icons.done_rounded, size: 50, color: Colors.green[400]),
            ),
            Text(
              "Your Mobile Number Verified",
              style: TextStyle(fontSize: 17),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "Press ok to Change your 4 digit login PIN",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ))
          ],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  logoutFirebase() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
