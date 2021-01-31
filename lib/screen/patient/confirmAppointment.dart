import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiCall.dart';
import 'patHome.dart';

class ConfirmAppointment extends StatefulWidget {
  String clinicId;
  String doctorId;
  String appDate;
  String patId;
  int amount;
  ConfirmAppointment(
      this.clinicId, this.doctorId, this.appDate, this.patId, this.amount);
  @override
  _ConfirmAppointmentState createState() => _ConfirmAppointmentState(
      this.clinicId, this.doctorId, this.appDate, this.patId, this.amount);
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  String clinicId;
  String doctorId;
  String appDate;
  String patId;
  int amount;
  _ConfirmAppointmentState(
      this.clinicId, this.doctorId, this.appDate, this.patId, this.amount);
  String appStatus = "";
  String appStatusMsg = "";

  @override
  void initState() {
    finalAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: appStatus == "1"
            ? Center(child: appConfirmedMsg(screenHeight, screenwidth))
            : appStatus.isEmpty
                ? Center(child: Spinner())
                : appStatus == "0"
                    ? Center(child: appFailedMsg(screenHeight, screenwidth))
                    : SizedBox());
  }

  Widget appConfirmedMsg(var screenHeight, var screenwidth) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.done_rounded,
                size: screenwidth / 8,
                color: Colors.green[400],
              ),
              Text(
                "Congratulations!",
                style: TextStyle(
                    fontSize: screenwidth / 10,
                    color: Colors.green[400],
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            "$appStatusMsg",
            style: TextStyle(
                fontSize: screenwidth / 23,
                fontWeight: FontWeight.w500,
                color: Colors.green[400]),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenwidth / 20),
            child: InkWell(
              child: Text(
                "Home",
                style: TextStyle(
                  fontSize: screenwidth / 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                homeRedirect();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget appFailedMsg(var screenHeight, var screenwidth) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: screenwidth / 8,
                color: Colors.red,
              ),
              Text(
                "Error",
                style: TextStyle(
                    fontSize: screenwidth / 8,
                    color: Colors.red,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            "$appStatusMsg",
            style: TextStyle(
                fontSize: screenwidth / 16,
                fontWeight: FontWeight.w500,
                color: Colors.red),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenwidth / 20),
            child: InkWell(
              child: Text(
                "Home",
                style: TextStyle(
                  fontSize: screenwidth / 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                homeRedirect();
              },
            ),
          )
        ],
      ),
    );
  }

  homeRedirect() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, SlideRightRoute(page: PatientHomePage()));
  }

  finalAppointment() async {
    final jsonData = {
      "app_date": appDate,
      "doctor_id": doctorId,
      "clinic_id": clinicId,
      "pat_id": patId,
      "amount": amount
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {"token": token};
    try {
      ApiCall objApi = new ApiCall();
      String url = "patient/appointmentFinal.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        var data = jsonDecode(status.body);
        print(status.body);
        if (data['status'] == "1") {
          setState(() {
            appStatus = data['status'];
            appStatusMsg = data['info'];
          });
        } else {
          setState(() {
            appStatus = data['status'];
            appStatusMsg = data['info'];
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
