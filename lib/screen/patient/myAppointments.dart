import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_appoint/models/patient/myAppointment.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiCall.dart';

class Myappointments extends StatefulWidget {
  @override
  _MyappointmentsState createState() => _MyappointmentsState();
}

class _MyappointmentsState extends State<Myappointments> {
  dynamic screenHeight;
  dynamic screenwidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
      ),
      body: Container(
        child: FutureBuilder(
          future: getMyAppointments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? Container(
                        margin: EdgeInsets.fromLTRB(
                            screenwidth / 25,
                            screenHeight / 60,
                            screenwidth / 25,
                            screenHeight / 60),
                        child: listViewWidget(snapshot.data))
                    : Center(
                        child: Text(
                          "No Appointment",
                          style: TextStyle(
                          fontSize: screenwidth / 25,
                          fontWeight: FontWeight.w500),
                        ),
                      )
                : Spinner();
          },
        ),
      ),
    );
  }

  Widget listViewWidget(List<Myappointment> appList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: appList.length,
        itemBuilder: (context, position) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  child: Text(
                appList[position].patientName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )),
              Container(
                margin: EdgeInsets.only(top: screenHeight / 22 * 0.2),
                child: Text("${appList[position].doctorName} ",
                style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight / 25 * 0.2),
                child: Row(
                  children: [
                    Text(
                        "${formatDateforUser(appList[position].appointmentDate.toString())}"),
                    Text(", Rs.${appList[position].totalAmount} "),
                  ],
                ),
              ),
              Divider(
                thickness: 1.5,
              )
            ],
          );
        });
  }

  Future<List<Myappointment>> getMyAppointments() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    ApiCall objApi = new ApiCall();
    final jsonData = {};
    var appList;
    Map<String, String> requestHeaders = {"token": token};
    try {
      String url = "patient/getmyAppointment.php";
      String encodedStr = jsonEncode(jsonData);
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
         //print(status.body);
        appList = myappointmentFromMap(status.body);
      }
    } catch (e) {}
    return appList;
  }

  String formatDateforUser(String date) {
    var parsedDate = DateTime.parse(date);
    String formatted = parsedDate.day.toString().padLeft(2, '0') +
        "-" +
        parsedDate.month.toString().padLeft(2, '0') +
        "-" +
        parsedDate.year.toString();

    return formatted;
  }
}
