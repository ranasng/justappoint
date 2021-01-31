import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/blocs/patient/select_patient_bloc.dart';
import 'package:just_appoint/models/patient/patientList.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiCall.dart';
import 'addnewPatient.dart';
import 'confirmAppointment.dart';

class AppointmentDetails extends StatefulWidget {
  String clinicId;
  String doctorId;
  String fee;
  AppointmentDetails(this.clinicId, this.doctorId, this.fee);
  @override
  _AppointmentDetailsState createState() =>
      _AppointmentDetailsState(this.clinicId, this.doctorId, this.fee);
}

enum GenderData { male, female, transgender }

class _AppointmentDetailsState extends State<AppointmentDetails> {
  String clinicId, doctorId, fee;
  bool patIsSelected = false, isconfirmPressed = false;
  String appDateselect = "",
      appDatestatus = "",
      appdateStatusMsg = "",
      patidSelected = "";
  List<dynamic> appDate;
  int selectedIndex;
  Future<List<PatientList>> pat;
  String patName, patDob, patSex;
  int total;
  _AppointmentDetailsState(this.clinicId, this.doctorId, this.fee);

  @override
  void initState() {
    getAppointmentDates();
    selectPatbloc.fetchAllPatients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(title: Text("Appointment Details")),
      body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                child: Center(
                  child: Text(
                    "Select Patient to book appoitment",
                    style: TextStyle(
                        fontSize: screenwidth / 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                child: StreamBuilder(
                  stream: selectPatbloc.allPatients,
                  builder:
                      (context, AsyncSnapshot<PatientList> snapshot) {
                    if (snapshot.hasData) {
                      return listViewWidget(snapshot);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Spinner();
                  },
                ),
                margin: EdgeInsets.all(10),
              ),
              Container(
                child: FlatButton(
                  child: Text("Add New Patient"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context, SlideRightRoute(page: AddnewPatient()));
                  },
                ),
              )
            ],
          )),
    );
  }

  Widget listViewWidget(AsyncSnapshot<PatientList> patlist) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: patlist.data.patList.length,
        itemBuilder: (context, position) {
          return InkWell(
            child: Card(
              color: selectedIndex != null && selectedIndex == position
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              child: ListTile(
                title: Text(
                  patlist.data.patList[position].patientName,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: selectedIndex != null && selectedIndex == position
                          ? Colors.white
                          : Colors.black),
                ),
                subtitle: Row(
                  children: [
                    Text("DOB: ${patlist.data.patList[position].patientDob}",
                        style: TextStyle(
                            color: selectedIndex != null &&
                                    selectedIndex == position
                                ? Colors.white
                                : Colors.black)),
                    Text(", ${patlist.data.patList[position].patientGender}",
                        style: TextStyle(
                            color: selectedIndex != null &&
                                    selectedIndex == position
                                ? Colors.white
                                : Colors.black)),
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndex = position;
                patIsSelected = true;
                patName = patlist.data.patList[position].patientName;
                patDob = patlist.data.patList[position].patientDob;
                patSex = patlist.data.patList[position].patientGender;
                patidSelected = patlist.data.patList[position].patientId;
                total = int.parse(fee) + 20;
              });
              showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.white,
                  // isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                  ),
                  builder: (context) {
                    return ConstrainedBox(
                      constraints: new BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 3.8,
                      ),
                      child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter state) {
                        return confirmAppointment(state, context);
                      }),
                    );
                  });
            },
          );
        });
  }

  getAppointmentDates() async {
    final jsonData = {"doctor_id": this.doctorId, "clinic_id": this.clinicId};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {"token": token};
    // print(jsonEncode(jsonData));
    try {
      ApiCall objApi = new ApiCall();
      String url = "patient/getAppoinntmentdate.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        //print(status.body);
        var appDateAvailable = jsonDecode(status.body);
        setState(() {
          appDate = appDateAvailable;
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  void showAlertDialogConfirm(BuildContext context, String patName, String dob,
      String gender, String appDate, int toatl) {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Confirm Appointment"),
          content: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Patient Name: $patName",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Date of Birth: $dob",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Gender: $gender",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Appointment Date: $appDate",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Consultation Fee: Rs.$fee",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Service Charge: Rs. 20",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Total: Rs. $total ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                textStyle: TextStyle(color: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          page: ConfirmAppointment(clinicId, doctorId, appDate,
                              patidSelected, total)));
                },
                child: Text("Confirm")),
          ],
        ));
  }

  Widget confirmAppointment(StateSetter updateState, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Please Select Your Appointment Date",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.width / 26)),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: DropdownButtonFormField(
              isDense: true,
              validator: (value) =>
                  value == null ? 'PLease Select Appointment Date' : null,
              decoration: InputDecoration(
                hintText: 'Select Appointment date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              items: appDate.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item['app_date']),
                  value: item['app_date'],
                );
              }).toList(),
              onChanged: (val) {
                // setState(() {
                appDateselect = val;
                checkAppointmentDate(updateState);
                // });
              },
              value: appDateselect.isNotEmpty ? appDateselect : null,
            ),
          ),
          appDatestatus == "0"
              ? Text(
                  "$appdateStatusMsg",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                )
              : SizedBox(),
          RaisedButton(
            onPressed: appDatestatus == "1"
                ? () {
                    showAlertDialogConfirm(
                        context, patName, patDob, patSex, appDateselect, total);
                  }
                : null,
            child: Text("Continue"),
            disabledColor: Colors.grey,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  checkAppointmentDate(StateSetter setState) async {
    final jsonData = {
      "app_date": appDateselect,
      "doctor_id": doctorId,
      "clinic_id": clinicId
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {"token": token};
    try {
      ApiCall objApi = new ApiCall();
      String url = "patient/checkAppoitmentAvailable.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        print(status.body);
        var data = jsonDecode(status.body);
        if (data['status'] == "1") {
          setState(() {
            appDatestatus = "1";
          });
        } else {
          setState(() {
            appDatestatus = "0";
            appdateStatusMsg = data['msg'];
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
