import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_appoint/models/doctor/myPatientList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiCall.dart';
import 'widget/spinner.dart';

class Mypatients extends StatefulWidget {
  @override
  _MypatientsState createState() => _MypatientsState();
}

class _MypatientsState extends State<Mypatients> {
  String appDate = "", apDateUserFriendly="";
  DateTime dateTime = DateTime.now();
  dynamic screenHeight;
  dynamic screenwidth;
  @override
  void initState() {
    DateTime now = DateTime.now();
    appDate = now.year.toString() +
        "-" +
        now.month.toString().padLeft(2, '0') +
        "-" +
        now.day.toString().padLeft(2, '0');
apDateUserFriendly=formatDateforUser(appDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Container(
        child: Column(
      children: [
        Material(
          elevation: 2,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Appointment Date: $apDateUserFriendly",
                  style: TextStyle(
                      fontSize: screenwidth / 25, fontWeight: FontWeight.w500),
                ),
                // Text(appDate),
                IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      showCallender();
                    }),
              ],
            ),
          ),
        ),
        FutureBuilder(
          future: getMyPatient(appDate),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: listViewWidget(snapshot.data))
                    : Center(
                        child: Container(
                            margin: EdgeInsets.only(top: screenHeight / 3),
                            child: Text(
                              "Sorry! No Patient Available",
                              style: TextStyle(
                                  fontSize: screenwidth / 25,
                                  fontWeight: FontWeight.w500),
                            )),
                      )
                : Container(
                  margin: EdgeInsets.only(top:10),
                  child: Spinner());
          },
        ),
      ],
    ));
  }

  Future<List<MypatientList>> getMyPatient(String appDate) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    String clinicId = sharedPreferences.getString("default_clinic_id");
    ApiCall objApi = new ApiCall();
    final jsonData = {"clinic_id": clinicId, "appointment_date": appDate};
    var patList;

    Map<String, String> requestHeaders = {"token": token};
    try {
      String url = "doctor/getmyPatientList.php";
      String encodedStr = jsonEncode(jsonData);
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
       // print(status.body);
        patList = mypatientListFromMap(status.body);
      }
    } catch (e) {}
    return patList;
  }

  Widget listViewWidget(List<MypatientList> patList) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: patList.length,
        itemBuilder: (context, position) {
          return InkWell(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "${patList[position].patientName}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 8, right: 8),
                    child: Row(
                      children: [
                        Text("${patList[position].patientGender} "),
                        Text(
                            "Age: ${getAge(patList[position].patientDob.toString())} Year"),
                      ],
                    ),
                  ),

                  
                ],
              ),
            ),
            onTap: () {},
          );
        });
  }

  String getAge(String appDate) {
    DateTime appdate = DateTime.parse(appDate);
    Duration dur = DateTime.now().difference(appdate);
    String differenceInYears = (dur.inDays / 365).floor().toString();
    return differenceInYears;
  }

  showCallender() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(dateTime.year - 1),
        lastDate: DateTime(dateTime.year, dateTime.month, dateTime.day + 10));
    if (picked != null && picked != dateTime)
      setState(() {
        dateTime = picked;
        appDate = formatDatetime(dateTime.toString());
        apDateUserFriendly=formatDateforUser(appDate);
      });
  }

  String formatDatetime(String date) {
    var parsedDate = DateTime.parse(date);
    String formatted = parsedDate.year.toString() +
        "-" +
        parsedDate.month.toString().padLeft(2, '0') +
        "-" +
        parsedDate.day.toString().padLeft(2, '0');

    return formatted;
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
