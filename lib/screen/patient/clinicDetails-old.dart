import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/models/patient/clinicDetails-old.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiCall.dart';
import '../drawerDesign.dart';
import 'appointmentDetails.dart';

class ClinicDetails extends StatefulWidget {
  String doctorId;
  ClinicDetails(this.doctorId);
  @override
  _ClinicDetailsState createState() => _ClinicDetailsState(this.doctorId);
}

class _ClinicDetailsState extends State<ClinicDetails> {
  String doctorId;
  _ClinicDetailsState(this.doctorId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinic Details"),
      ),
      drawer: LeftDrawer(),
      body: createViewWidget(),
    );
  }

  Future<List<ClinicDetailsModal>> getClinicDetails() async {
    //print(this.doctorId);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {
      "token": token,
      "Content-Type": "application/json"
    };

    final jsonData = {
      "doctor_id": this.doctorId,
    };
    var clinicDetailsModal;
    ApiCall objApi = new ApiCall();
    try {
      String url = "patient/getbookingClinicDetails.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        print(status.body);
        clinicDetailsModal = clinicDetailsModalFromMap(status.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return clinicDetailsModal;
  }

  Widget createViewWidget() {
    return FutureBuilder(
      future: getClinicDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData
                ? Container(
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, position) {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  child: Text(
                                    snapshot.data[position].clinicName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                                Divider(thickness: 2.0),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount:
                                        snapshot.data[position].schedule.length,
                                    itemBuilder: (context, indx) {
                                      /* return Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(2),
                                          1: FlexColumnWidth(1),
                                          2: FlexColumnWidth(1),
                                        },
                                        // border: TableBorder.all(width: 0.0),
                                        children: [
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  snapshot.data[position]
                                                      .schedule[indx].dayName,
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Text(snapshot.data[position]
                                                .schedule[indx].startTime),
                                            Text(snapshot.data[position]
                                                .schedule[indx].endTime),
                                          ]),
                                        ],
                                      ); */
                                      return Column(
children: [
  Row(children: [
    Text("Address"),
    Text(snapshot.data[position].address)
  ],)
],
                                      );
                                    }),
                                snapshot.data[position].status == "0"
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Sorry! Currently appointment not available for this Clinic",
                                          style:
                                              TextStyle(color: Colors.red[700]),
                                        ),
                                      )
                                    : SizedBox(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: FlatButton(
                                        color: Theme.of(context).primaryColor,
                                        //padding: EdgeInsets.only(left:10),
                                        textColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        onPressed: snapshot
                                                    .data[position].status ==
                                                "1"
                                            ? () {
                                                // showAlertDialog(context);

                                                Navigator.push(
                                                    context,
                                                    SlideRightRoute(
                                                        page: AppointmentDetails(
                                                            snapshot
                                                                .data[position]
                                                                .clinicId,this.doctorId,snapshot
                                                                .data[position]
                                                                .baseFee)));
                                              }
                                            : null,
                                        child: Text("Book Appointment"),
                                      ),
                                    ),
                                    snapshot.data[position].iscoordinate == 1
                                        ? IconButton(
                                            icon:
                                                Icon(Icons.location_on_rounded),
                                            onPressed: () {
                                              print(snapshot
                                                      .data[position].latitude +
                                                  "~" +
                                                  snapshot.data[position]
                                                      .longitude);
                                            })
                                        : IconButton(
                                            icon: Icon(
                                                Icons.location_off_rounded),
                                            onPressed: null)
                                  ],
                                )
                              ],
                            ),
                          );
                        }))
                : Center(
                    child: Text("No Clinic Found"),
                  )
            : Spinner();
      },
    );
  }
}
