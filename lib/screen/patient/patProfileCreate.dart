import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/device_info.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:just_appoint/screen/graphics/custom_icons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiCall.dart';
import '../../tokenManager.dart';
import '../splash.dart';
import 'patHome.dart';

class PatProfileCreate extends StatefulWidget {
  @override
  _PatProfileCreateState createState() => _PatProfileCreateState();
}

class _PatProfileCreateState extends State<PatProfileCreate> {
  @override
  
  var basicFormKey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController mname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  bool maleClicked = false, femaleClicke = false, buttonClicked = false;
  String deviceId = "";
  String token = "";
  DeviceDetails device = new DeviceDetails();
  DateTime dateTime = DateTime.now();
   TokenManager objToken = new TokenManager();
  void initState() {
    device.getDeviceId().then((String value) {
      deviceId = value;
      objToken.getToken().then((String tokenValue) {
        token = tokenValue;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Profile"),
       actions: [
         IconButton(icon: Icon(Icons.logout), onPressed: (){
logOut(context);
         })
       ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: basicFormKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: fname,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter First Name";
                  }
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: mname,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                ],
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: 'Middle Name',
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: lname,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter Last Name";
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: email,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(
                      RegExp("[A-Za-z0-9.@_-]"))
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter Email Id";
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Email Id',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Gender :",
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.1 / 2),
                      child: GestureDetector(
                        child: Container(
                          height: screenHeight * 0.2 / 3,
                          width: screenwidth * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: maleClicked
                                ? Color(0xff08838B)
                                : Colors.grey[350],
                          ),
                          //padding: EdgeInsets.fromLTRB(30, 17, 30, 17),
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.male,
                                color:
                                    maleClicked ? Colors.white : Colors.black,
                              ),
                              SizedBox(
                                width: screenwidth * 0.1 / 9,
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                    color: maleClicked
                                        ? Colors.white
                                        : Colors.black),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (maleClicked == false) {
                              maleClicked = true;
                              femaleClicke = false;
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.1 / 2),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: femaleClicke
                                ? Color(0xff08838B)
                                : Colors.grey[350],
                          ),
                          padding: EdgeInsets.only(left: 20),
                          height: screenHeight * 0.2 / 3,
                          width: screenwidth * 0.3,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.female,
                                color:
                                    femaleClicke ? Colors.white : Colors.black,
                              ),
                              SizedBox(
                                width: screenwidth * 0.1 / 9,
                              ),
                              Text(
                                "Female",
                                style: TextStyle(
                                    color: femaleClicke
                                        ? Colors.white
                                        : Colors.black),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (femaleClicke == false) {
                              femaleClicke = true;
                              maleClicked = false;
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              buttonClicked
                  ? maleClicked == femaleClicke
                      ? Text(
                          "Please Select Gender",
                          style: TextStyle(color: Colors.red[800]),
                        )
                      : SizedBox()
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: dob,
                readOnly: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Select Date of Borth";
                  }
                },
                onTap: () {
                   showCallender();
                  
                },
                decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                onPressed: buttonClicked ? null:() {                
                  setState(() {
                    buttonClicked = true;
                    if (basicFormKey.currentState.validate()) {
                      createPatientProfile();
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Create Profile",
                      ),
                     
                    ],
                  ),
                ),
              ),
              buttonClicked? Container(
                margin: EdgeInsets.only(top:screenHeight/41),
                child: Spinner()): SizedBox()
            ],
          ),
        ),
      ),
    );
  }

 

  showCallender() async {
   
   final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(dateTime.year-100),
        lastDate: DateTime(dateTime.year,dateTime.month,dateTime.day ));
    if (picked != null && picked != dateTime)
      setState(() {
        dateTime = picked;
        dob.text=formatDatetime(dateTime.toString());
      });
    
  }
  String formatDatetime(String date) {
    var parsedDate = DateTime.parse(date);
    String formatted= parsedDate.day.toString().padLeft(2,'0')+"-"+parsedDate.month.toString().padLeft(2,'0')+"-"+parsedDate.year.toString();
  
    return formatted;
  }

  createPatientProfile() async{
String gender = "";
    if (maleClicked) {
      gender = "Male";
    } else if (femaleClicke) {
      gender = "Female";
    }
   // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final jsonData = {
     // "mobile": sharedPreferences.getString("mobileNo"),
      "fname": fname.text,
      "mname": mname.text,
      "lname": lname.text,
      "email": email.text,
      "sex": gender,
      "dob": dob.text,
      "deviceid": deviceId,
    };
    Map<String, String> requestHeaders = {"token":token};
    // print(jsonEncode(jsonData));
    try {
      ApiCall objApi = new ApiCall();
      String url = "patient/createPatprofile.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
      //  print(status.body);
        var decodedStr = jsonDecode(status.body);
        if (decodedStr['status'] == 1) {
          objToken.setProfileSession(true,decodedStr['firstName']);   
          objToken.setEmailSession(decodedStr['emailId']);       
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, SlideRightRoute(page: PatientHomePage()));
        } else {
         // showAlertDialog(context, decodedStr['Info']);
         setState(() {
          buttonClicked = false;
        });
        }
       
      }
    } catch (e) {
      // print(e.toString());
    }
  }
  logOut(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    {
      Navigator.pushReplacement(context, SlideRightRoute(page: SplashScreen()));
    }
  }
  
}
