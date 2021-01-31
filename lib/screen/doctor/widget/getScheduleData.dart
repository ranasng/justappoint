import 'dart:convert';

import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/models/doctor/ClinicScheduleData.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiCall.dart';
import '../createSchedule.dart';

class ScheduleDataget extends StatefulWidget {
  String clinicId;
  String clinicName;
  @override
  _ScheduleDatagetState createState() => _ScheduleDatagetState();
  ScheduleDataget({this.clinicId,this.clinicName});
}

class _ScheduleDatagetState extends State<ScheduleDataget> {
  bool disableAppointment=false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: getSavedSchedule(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData
                ? Column(
                  children: [
                    /* Container(
                      child: Row(children: [
                        Text("Disable Appointment"),
                         Switch(
                  value: disableAppointment,
                  onChanged: (value) {
                    setState(() {
                      disableAppointment=value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                )
                      ],),
                    ), */
                    Container(
                        margin: EdgeInsets.only(left: 15),
                        child: listViewWidget(snapshot.data)),
                        //FlatButton(onPressed: () {}, child: Text("Modify Schedule"))
                  ],
                )
                : Center(
                    child: Column(
                      children: [
                        Text("Appointment Not Scheduled"),
                        FlatButton(
                            onPressed: () {
                               Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: CreateSchedule(widget.clinicName,widget.clinicId)));

                            }, child: Text("Create Schedule"))
                      ],
                    ),
                  )
            : Center(child: Spinner());
      },
    ));
  }

  Future<List<ClinicScheduleData>> getSavedSchedule() async {
    var sharedPreferences = await SharedPreferences.getInstance();
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

        if (decodedStr['status'] == 1) {
          clinicScheduleData =
              clinicScheduleDataFromMap(jsonEncode(decodedStr['scheduleData']));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return clinicScheduleData;
  }

  Widget listViewWidget(List<ClinicScheduleData> clinicSchedule) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: clinicSchedule.length,
        itemBuilder: (context, position) {
          return ListTile(
            title: Text(
              "${clinicSchedule[position].dayName}",
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Text("Start Time: ${clinicSchedule[position].startTime}"),
                    Text(" End Time: ${clinicSchedule[position].endTime}"),
                  ],
                ),
                
              ],
            ),
          );
        });
  }
}
