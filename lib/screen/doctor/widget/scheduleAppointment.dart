import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../apiCall.dart';
import '../../../tokenManager.dart';
import 'spinner.dart';

class ScheduleAppointment extends StatefulWidget {
  
  String clinicId;
  @override
  _ScheduleAppointmentState createState() => _ScheduleAppointmentState();
  ScheduleAppointment({this.clinicId});
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  SharedPreferences sharedPreferences;
  bool switchSunday = false;
  bool switchMonday = false;
  bool switchTuesday = false;
  bool switchWednesday = false;
  bool switchThrusday = false;
  bool switchFriday = false;
  bool switchSaturday = false, sevendaySwitch = false, isSaveClicked=false;
  final TextEditingController startController = new TextEditingController();
  final TextEditingController endController = new TextEditingController();

  final TextEditingController startControllerSunday =
      new TextEditingController();
  final TextEditingController endControllerSunday = new TextEditingController();
  final TextEditingController startControllerMonday =
      new TextEditingController();
  final TextEditingController endControllerMonday = new TextEditingController();
  final TextEditingController startControllerTuesday =
      new TextEditingController();
  final TextEditingController endControllerTuesday =
      new TextEditingController();
  final TextEditingController startControllerWed = new TextEditingController();
  final TextEditingController endControllerWed = new TextEditingController();
  final TextEditingController startControllerThr = new TextEditingController();
  final TextEditingController endControllerThr = new TextEditingController();
  final TextEditingController startControllerFri = new TextEditingController();
  final TextEditingController endControllerFri = new TextEditingController();
  final TextEditingController startControllerSat = new TextEditingController();
  final TextEditingController endControllerSat = new TextEditingController();  
  TokenManager objToken = new TokenManager();
  String token = "";
  @override
  void initState() {
    objToken.getToken().then((String tokenValue) {
        token = tokenValue;
      });   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    double paddingDay = screenwidth / 15;
    return Container(
      child: Column(
        children: [
          /* Container(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Appointment Status: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Switch(
                  value: appStatus,
                  onChanged: (value) {
                    setState(() {
                      appStatus = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                sevendaySwitch
                    ? Expanded(
                        flex: 2,
                        child: showStartEnd(startController, endController, 1))
                    : SizedBox()
              ],
            ),
          ), */
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Seven Day",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Switch(
                  value: sevendaySwitch,
                  onChanged: (value) {
                    setState(() {
                      sevendaySwitch = value;
                      setSevenDaySwitch(sevendaySwitch);
                      setSevenDayEnd("");
                      setSevenDayStart("");
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                sevendaySwitch
                    ? Expanded(
                        flex: 2,
                        child: showStartEnd(startController, endController, 1))
                    : SizedBox()
              ],
            ),
          ),
          Divider(
            thickness: 2.0,
            height: 0.2,
          ),
          Row(
            children: [
              Expanded(child: Text("Sunday")),
              Switch(
                value: switchSunday,
                onChanged: (value) {
                  setState(() {
                    switchSunday = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchSunday
                  ? Expanded(
                      flex: 2,
                      child: showStartEnd(
                          startControllerSunday, endControllerSunday, 0))
                  : SizedBox(),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Text("Monday")),
              Switch(
                value: switchMonday,
                onChanged: (value) {
                  setState(() {
                    switchMonday = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchMonday
                  ? Expanded(
                      flex: 2,
                      child: showStartEnd(
                          startControllerMonday, endControllerMonday, 0))
                  : SizedBox(),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Text("Tuesday")),
              Switch(
                value: switchTuesday,
                onChanged: (value) {
                  setState(() {
                    switchTuesday = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchTuesday
                  ? Expanded(
                      flex: 2,
                      child: showStartEnd(
                          startControllerTuesday, endControllerTuesday, 0))
                  : SizedBox(),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Wednesday",
                ),
              ),
              Switch(
                value: switchWednesday,
                onChanged: (value) {
                  setState(() {
                    switchWednesday = value;
                    //print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchWednesday
                  ? Expanded(
                      flex: 2,
                      child:
                          showStartEnd(startControllerWed, endControllerWed, 0))
                  : SizedBox(),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Text("Thursday")),
              Switch(
                value: switchThrusday,
                onChanged: (value) {
                  setState(() {
                    switchThrusday = value;
                    //print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchThrusday
                  ? Expanded(
                      flex: 2,
                      child:
                          showStartEnd(startControllerThr, endControllerThr, 0))
                  : SizedBox(),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Text("Friday")),
              Switch(
                value: switchFriday,
                onChanged: (value) {
                  setState(() {
                    switchFriday = value;
                    //print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchFriday
                  ? Expanded(
                      flex: 2,
                      child:
                          showStartEnd(startControllerFri, endControllerFri, 0))
                  : SizedBox(),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: Text("Saturday")),
              Switch(
                value: switchSaturday,
                onChanged: (value) {
                  setState(() {
                    switchSaturday = value;
                    //print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              switchSaturday
                  ? Expanded(
                      flex: 2,
                      child:
                          showStartEnd(startControllerSat, endControllerSat, 0))
                  : SizedBox()
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: RaisedButton(
              // elevation: 7.0,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              onPressed: isSaveClicked?null :() {
                setState(() {
                  isSaveClicked=true;
                  saveClinicSchedule();
                });
                
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Save Timing",
                      
                    ),
                    Icon(Icons.save,
                    size: 16,
                    )
                  ],
                ),
              ),
            ),
          ),
          isSaveClicked ? Container(
            margin: EdgeInsets.only(top:10),
            child: Center(child:Spinner()),
          ) :SizedBox()
        ],
      ),
    );
  }

  _showTimePicker(BuildContext cntxt, TextEditingController cntlr,
      int isSevenDay, String type) {
    showTimePicker(
        context: cntxt,
        initialTime: TimeOfDay(hour: 12, minute: 00),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        }).then((time) {
      if (time != null) {
//cntlr.text = time.format(context);
        String timeVal = time.hour.toString().padLeft(2, '0') +
            ":" +
            time.minute.toString().padLeft(2, '0');
        cntlr.text = timeVal;
        if (isSevenDay == 1) {
          if (type == "start") {
            setSevenDayStart(timeVal);
          } else if (type == "end") {
            setSevenDayEnd(timeVal);
          }
        }
      }
    });
  }

  Widget showStartEnd(
      TextEditingController start, TextEditingController end, int isSeven) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: start,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please Enter Start Time";
                }
              },
              onTap: () {
                _showTimePicker(context, start, isSeven, 'start');
              },
              decoration: InputDecoration(
                labelText: 'Start Time',
                //hintText: 'Start Time',
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: end,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Please Enter End Time";
                }
              },
              onTap: () {
                _showTimePicker(context, end, isSeven, 'end');
              },
              decoration: InputDecoration(
                labelText: 'End Time',
                //hintText: 'Start Time',
              ),
            ),
          )
        ],
      ),
    );
  }

  saveClinicSchedule() async {
    sharedPreferences = await SharedPreferences.getInstance();
    ApiCall objApi = new ApiCall();
    Map<String, String> requestHeaders = {"token":token};
    final jsonData = {
      "clinic_id": widget.clinicId,
     // "doctor_id": sharedPreferences.getString("userId"),
      "sunday": switchSunday,
      "sunday_start_time": startControllerSunday.text,
      "sunday_end_time": endControllerSunday.text,
      "monday": switchMonday,
      "monday_start_time": startControllerMonday.text,
      "monday_end_time": endControllerMonday.text,
      "tuesday": switchTuesday,
      "tuesday_start_time": startControllerTuesday.text,
      "tuesday_end_time": endControllerTuesday.text,
      "wednesday": switchWednesday,
      "wednesday_start_time": startControllerWed.text,
      "wednesday_end_time": endControllerWed.text,
      "thursday": switchThrusday,
      "thursday_start_time": startControllerThr.text,
      "thursday_end_time": endControllerThr.text,
      "friday": switchFriday,
      "friday_start_time": startControllerFri.text,
      "friday_end_time": endControllerFri.text,
      "saturday": switchSaturday,
      "saturday_start_time": startControllerSat.text,
      "saturday_end_time": endControllerSat.text,
    };

    try {
      String url = "doctor/saveClinicSchedule.php";
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      //String encodedStr = "";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        var decodedStr = jsonDecode(status.body);
        setState(() {
          isSaveClicked=false;
        });
        showAlertDialog(context, decodedStr['Info']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showAlertDialog(BuildContext context, String msg) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(msg),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setSevenDaySwitch(bool val) {
    switchSunday = val;
    switchMonday = val;
    switchTuesday = val;
    switchWednesday = val;
    switchThrusday = val;
    switchFriday = val;
    switchSaturday = val;
  }

  setSevenDayStart(String val) {
    startControllerSunday.text = val;
    startControllerMonday.text = val;
    startControllerTuesday.text = val;
    startControllerWed.text = val;
    startControllerThr.text = val;
    startControllerFri.text = val;
    startControllerSat.text = val;
  }

  setSevenDayEnd(String val) {
    endControllerSunday.text = val;
    endControllerMonday.text = val;
    endControllerTuesday.text = val;
    endControllerWed.text = val;
    endControllerThr.text = val;
    endControllerFri.text = val;
    endControllerSat.text = val;
  }

  /* getSavedSchedule() async {
    sharedPreferences = await SharedPreferences.getInstance();
    ApiCall objApi = new ApiCall();
    Map<String, String> requestHeaders = {"token":sharedPreferences.getString('token')};
    final jsonData = {
      "clinic_id": widget.clinicId
    };
var clinicScheduleData;
    try {
      String url = "doctor/getSavedSchedule.php";
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        var jsonStr = status.body;
        var decodedStr = jsonDecode(jsonStr);
        print(decodedStr['status']);
        if (decodedStr['status'] == 1) {
           clinicScheduleData = decodedStr['scheduleData'];
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return clinicScheduleData;
  } */
}
