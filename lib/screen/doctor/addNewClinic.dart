import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_appoint/screen/graphics/custom_icons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiCall.dart';
import '../../tokenManager.dart';
import 'widget/spinner.dart';

class AddnewClinic extends StatefulWidget {
  @override
  _AddnewClinicState createState() => _AddnewClinicState();
}

class _AddnewClinicState extends State<AddnewClinic> {
  TextEditingController clinicName = TextEditingController();
  TextEditingController fee = TextEditingController();
  TextEditingController maxPatient = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController location = TextEditingController();
  List<dynamic> dataStateList = List();
  List<dynamic> dataCityList = List();
  String latLong = "";
  String stateId, cityId;
  bool islocationCollected = false, isClinicClicked = false;
  var clinicFormKey = GlobalKey<FormState>();
  ApiCall objApi = new ApiCall();
  SharedPreferences sharedPreferences;
  var locationData = "0~0";
  TokenManager objToken = new TokenManager();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String token = "";
  @override
  void initState() {
    objToken.getToken().then((String tokenValue) {
      token = tokenValue;
      getStateList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Add New Clinic"),
      ),
      body: Container(
        child: formView(screenHeight),
      ),
    );
  }

  Widget formView(var screenHeight) {
    return Container(
      margin: EdgeInsets.all(20),
      child: isClinicClicked
          ? Spinner()
          : Form(
              key: clinicFormKey,
              child: ListView(
                children: [
                  //Text(""),
                  TextFormField(
                    controller: clinicName,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please Enter Clinic Name";
                      }
                    },
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        labelText: 'Clinic Name',
                        prefixIcon: Icon(Icons.arrow_right),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: fee,
                      keyboardType: TextInputType.number,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Consultation Fee";
                        }
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                          labelText: 'Consultation Fee',
                          prefixIcon: Icon(
                            CustomIcons.rupee,
                            size: 15,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: maxPatient,
                      keyboardType: TextInputType.number,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Maximum Patient";
                        }
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                          labelText: 'Maximum Patient',
                          prefixIcon: Icon(Icons.arrow_right),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: address,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Clinic Address";
                        }
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                          labelText: 'Clinic Address',
                          prefixIcon: Icon(Icons.arrow_right),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                            )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        isDense: true,
                        itemHeight: 50,
                        hint: Text("Select State"),
                        validator: (value) =>
                            value == null ? 'PLease Select State' : null,
                        items: dataStateList.map((item) {
                          return new DropdownMenuItem<String>(
                            child: new Text(item['state_name']),
                            value: item['state_id'],
                          );
                        }).toList(),
                        value: stateId,
                        onChanged: (String str) {
                          setState(() {
                            stateId = str;
                            getCityList(int.parse(str));
                          });
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                            )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        isDense: true,
                        hint: Text("Select City"),
                        validator: (value) =>
                            value == null ? 'PLease Select City' : null,
                        items: dataCityList.map((item) {
                          return new DropdownMenuItem<String>(
                            child: new Text(item['city_name']),
                            value: item['city_id'],
                          );
                        }).toList(),
                        value: cityId,
                        onChanged: (String str) {
                          print(str);
                          setState(() {
                            cityId = str;
                          });
                        },
                      )),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          // elevation: 7.0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            Widget cancelButton = FlatButton(
                              child: Text("Not Now"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = FlatButton(
                              child: Text("Yes I'm in Clinic"),
                              onPressed: () async {
                                locationData = await getLocation();
                                setState(() {
                                  islocationCollected = true;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                            List<Widget> btns = [continueButton, cancelButton];
                            String msg =
                                "It will collect current location of your clinic. Please make sure that you are in clinic";
                            showAlertDialog(context, msg, "Notice", btns);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              islocationCollected
                                  ? Icon(Icons.location_on)
                                  : Icon(Icons.location_off),
                              Text(
                                "Clinic Location",
                              ),
                            ],
                          ),
                        ),
                      ),
                      islocationCollected
                          ? Container(
                              child: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    removeLocation();
                                  }),
                            )
                          : SizedBox()
                    ],
                  ),
                  RaisedButton(
                    // elevation: 7.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        if (clinicFormKey.currentState.validate()) {
                          isClinicClicked = true;
                          clinicRegistration(screenHeight);
                          //Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Add Clinic",
                        ),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  clinicRegistration(var height) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String defaultClinicId = sharedPreferences.getString("default_clinic_id");
    var location = locationData.split("~");
    ApiCall objApi = new ApiCall();
    final jsonData = {
      "clinic_name": clinicName.text,
      "base_fee": fee.text,
      "max_patient": maxPatient.text,
      "address": address.text,
      "state_id": stateId,
      "city_id": cityId,
      "latitude": location[0],
      "longitude": location[1],
      "default_clinic": defaultClinicId
    };
    Map<String, String> requestHeaders = {"token": token};
    try {
      String url = "doctor/createClinic.php";
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        print(status.body);
        var decodedStr = jsonDecode(status.body);
        if (decodedStr['status'] == 1) {
          objToken.setDefaultClinicSession(decodedStr['default_clinic_id']);
        }
        showSnackBar(decodedStr['Info'], height);
        setState(() {
          isClinicClicked = false;
          clinicName.clear();
          fee.clear();
          maxPatient.clear();
          address.clear();
          cityId = null;
          stateId = null;
          locationData = "0~0";
        });
      }
    } catch (e) {}
  }

  getStateList() async {
    try {
      String url = "doctor/getStateList.php";
      Map<String, String> requestHeaders = {};
      final status = await objApi.callGetMethod(url, requestHeaders);
      if (status.statusCode == 200) {
        var responseBody = jsonDecode(status.body);
        setState(() {
          dataStateList = responseBody;
        });
      }
    } catch (e) {}
  }

  showAlertDialog(
      BuildContext context, String msg, String titile, List<Widget> buttons) {
    // set up the buttons
    /* Widget cancelButton = FlatButton(
      child: Text("Not Now"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ); */
    /* Widget continueButton = FlatButton(
      child: Text("Yes I'm in Clinic"),
      onPressed: () async {
        locationData = await getLocation();
        setState(() {
          islocationCollected = true;
        });
        Navigator.of(context).pop();
      },
    ); */

    // set up the AlertDialog
    /* AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text(
          "It will collect current location of your clinic. Please make sure that you are in clinic"),
      actions: buttons,
    ); */
    AlertDialog alert = AlertDialog(
      title: Text(titile),
      content: Text(msg),
      actions: buttons,
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position.latitude.toString() + "~" + position.longitude.toString();
  }

  removeLocation() {
    setState(() {
      locationData = "0~0";
      islocationCollected = false;
    });
  }

  getCityList(int stateId) async {
    final jsonData = {"state_id": stateId};
    Map<String, String> requestHeaders = {};
    // print(jsonEncode(jsonData));
    try {
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      String url = "doctor/getCityList.php";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        var decodedStr = base64.decode(status.body);
        var decodedJson = jsonDecode(utf8.decode(decodedStr));
        setState(() {
          dataCityList = decodedJson;
        });
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
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
