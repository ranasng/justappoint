import 'dart:convert';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/screen/doctor/docHome.dart';
import 'package:flutter/material.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiCall.dart';
import '../../device_info.dart';
import '../../tokenManager.dart';

class EducationDetls extends StatefulWidget {
  var finalRecord = new Map();
  EducationDetls(this.finalRecord);
  @override
  _EducationDetlsState createState() => _EducationDetlsState(this.finalRecord);
}

class _EducationDetlsState extends State<EducationDetls> {
  var finalRecord = new Map();
  ApiCall objApi = new ApiCall();
  String deviceId = "";
  SharedPreferences sharedPreferences;
  DeviceDetails device = new DeviceDetails();
  _EducationDetlsState(this.finalRecord);
  var educationFormKey = GlobalKey<FormState>();
  String degreeSelect = "",
      mdinSelect = "",
      specialityVal = "",
      stateCouncilVal;
  TextEditingController experienceinYear = TextEditingController();
  TextEditingController mciNo = TextEditingController();
  List<dynamic> dataSpeciality = List();
  List<dynamic> datadegree = List();
  List<dynamic> dataMd = List();
  List<dynamic> stateCounilList = List();
  bool isClicked = false;
  var docdegreeJson;
  TokenManager objToken = new TokenManager();
  String token = "";
  @override
  void initState() {
    getDegreeSpeciality();
    getSStateCouncil();

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
    dynamic screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Education Details"),
      ),
      body: Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: educationFormKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: DropdownButtonFormField(
                        isDense: true,
                        decoration: InputDecoration(
                          hintText: 'Degree In',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'PLease Select Your Degree' : null,
                        items: datadegree.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['degree_name']),
                            value: item['degree_id'],
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            degreeSelect = val;
                          });
                        },
                        value: degreeSelect.isNotEmpty ? degreeSelect : null,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: DropdownButtonFormField(
                        isDense: true,
                        decoration: InputDecoration(
                          hintText: 'Md In',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: dataMd.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['md_name']),
                            value: item['md_id'],
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            mdinSelect = val;
                          });
                        },
                        value: mdinSelect.isNotEmpty ? mdinSelect : null,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          hintText: 'Speciality',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        isDense: true,
                        items: dataSpeciality.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['splty_name']),
                            value: item['splty_id'],
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            specialityVal = val;
                          });
                        },
                        value: specialityVal.isNotEmpty ? specialityVal : null,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: experienceinYear,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Experience";
                          }
                        },
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            labelText: 'Experience in Years',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          hintText: 'State Council',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        isDense: true,
                        hint: Text("State Council"),
                        value: stateCouncilVal,
                        validator: (value) => value == null
                            ? 'PLease Select State Council'
                            : null,
                        items: stateCounilList.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['state_council_name']),
                            value: item['state_council_id'],
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            stateCouncilVal = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: mciNo,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Registration No";
                          }
                        },
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            labelText: 'Registration No',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: RaisedButton(
                        // elevation: 7.0,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        onPressed: isClicked? null : () {
                          setState(() {
                            if (educationFormKey.currentState.validate()) {
                              isClicked = true;
                              registerDoctor();
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Create Account",
                              ),
                            ),
                            Icon(
                              Icons.save,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                    isClicked ? Container(margin:EdgeInsets.only(top:10)  ,                  
                    child: Spinner(),): SizedBox()
                  ],
                ),
              ),
            ),
    );
  }

  getDegreeSpeciality() async {
    try {
      String url = "doctor/getallDegree.php";
       Map<String, String> requestHeaders = {};
      final status = await objApi.callGetMethod(url,requestHeaders);
      if (status.statusCode == 200) {
        var responseBody = jsonDecode(status.body);
        setState(() {
          dataSpeciality = responseBody['speciality'];
          datadegree = responseBody['doc_degree'];
          dataMd = responseBody['md_degree'];
        });
      }
    } catch (e) {}
  }

  getSStateCouncil() async {
    try {
      String url = "doctor/getCouncil.php";
       Map<String, String> requestHeaders = {};
      final status = await objApi.callGetMethod(url,requestHeaders);
      if (status.statusCode == 200) {
        var responseBody = jsonDecode(status.body);
        setState(() {
          stateCounilList = responseBody;
        });
      }
    } catch (e) {}
  }

  registerDoctor() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonData = {
      "fname": finalRecord['fname'],
      "mname": finalRecord['mname'],
      "lname": finalRecord['lname'],
      "email": finalRecord['emailid'],
      "sex": finalRecord['gender'],
      "dob": finalRecord['dob'],
      "initial": finalRecord['initial'],
      "deviceid": deviceId,
      "degree": degreeSelect,
      "mdin": mdinSelect,
      "speciality": specialityVal,
      "experience": experienceinYear.text,
      "statemedcouncil": stateCouncilVal,
      "mcino": mciNo.text
    };
    //var token=objToken.getToken();
    Map<String, String> requestHeaders = {"token": token};
    // print(jsonEncode(jsonData));
    try {
      String url = "doctor/createProfile.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        var decodedStr = jsonDecode(status.body);
        if (decodedStr['status'] == 1) {
          //sharedPreferences.setBool("isProfile", true);
           objToken.setProfileSession(true,decodedStr['first_name']);
           objToken.setEmailSession(decodedStr['emailId']);
           objToken.setDefaultClinicSession(decodedStr['default_clinic_id']);
          /* sharedPreferences.setString("userId", decodedStr['userId']);
          sharedPreferences.setString("emailId", decodedStr['emailId']); */
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, SlideRightRoute(page: DoctorHomePage()));
        } else {
          showAlertDialog(context, decodedStr['Info']);
        }
        setState(() {
          isClicked = false;
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  showAlertDialog(BuildContext context, String msg) {
    // set up the buttons
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(msg),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
