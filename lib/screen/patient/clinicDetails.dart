import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/blocs/patient/clinic_to_book_bloc.dart';
import 'package:just_appoint/models/patient/clinicDetails.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:just_appoint/screen/graphics/custom_icons_icons.dart';
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
  final _clinicListBloc = new ClinictobookBloc();
  @override
  void initState() {
    _clinicListBloc.docId = this.doctorId;
    _clinicListBloc.eventSink.add(ClinicListAction.FetchClinicByDoctor);
    super.initState();
  }

  @override
  void dispose() {
    _clinicListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clinic Details"),
      ),
      // drawer: LeftDrawer(),
      body: createViewWidget(_clinicListBloc),
    );
  }

  Widget createViewWidget(var blocData) {
    var screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: blocData.clinicListStream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error),
          );
        return snapshot.hasData
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
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Text(
                                snapshot.data[position].clinicName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 23),
                              ),
                            ),
                            Divider(thickness: 2.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(
                                        fontSize: screenWidth / 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    snapshot.data[position].address,
                                    style:
                                        TextStyle(fontSize: screenWidth / 25),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Text("State: ",
                                      style: TextStyle(
                                          fontSize: screenWidth / 25,
                                          fontWeight: FontWeight.w500)),
                                  Text(snapshot.data[position].stateName,
                                      style: TextStyle(
                                        fontSize: screenWidth / 25,
                                      )),
                                  SizedBox(
                                    width: screenWidth / 18,
                                  ),
                                  Text("City: ",
                                      style: TextStyle(
                                          fontSize: screenWidth / 25,
                                          fontWeight: FontWeight.w500)),
                                  Text(snapshot.data[position].cityName)
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Text("Consultation Fee: ",
                                      style: TextStyle(
                                          fontSize: screenWidth / 25,
                                          fontWeight: FontWeight.w500)),
                                  //Icon(CustomIcons.rupee, size: screenWidth/25,),
                                  Text("Rs. ${snapshot.data[position].baseFee}",
                                      style:
                                          TextStyle(fontSize: screenWidth / 25))
                                ],
                              ),
                            ),
                            snapshot.data[position].status == "0"
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Sorry! Currently appointment not available for this Clinic",
                                      style: TextStyle(color: Colors.red[700]),
                                    ),
                                  )
                                : SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: FlatButton(
                                    color: Theme.of(context).primaryColor,
                                    //padding: EdgeInsets.only(left:10),
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    onPressed:
                                        snapshot.data[position].status == "1"
                                            ? () {
                                                //  showAlertDialog(context,'Appointment Booking System is Under Development. Very Soon this Service will be Available for you.');
/* Uncomment to enable bookings*/
                                                Navigator.push(
                                                    context,
                                                    SlideRightRoute(
                                                        page: AppointmentDetails(
                                                            snapshot
                                                                .data[position]
                                                                .clinicId,
                                                            this.doctorId,
                                                            snapshot
                                                                .data[position]
                                                                .baseFee)));
                                              }
                                            : null,
                                    child: Text("Book Appointment"),
                                  ),
                                ),
                                snapshot.data[position].iscoordinate == 1
                                    ? IconButton(
                                        icon: Icon(Icons.location_on_rounded),
                                        onPressed: () {
                                          print(
                                              snapshot.data[position].latitude +
                                                  "~" +
                                                  snapshot.data[position]
                                                      .longitude);
                                        })
                                    : IconButton(
                                        icon: Icon(Icons.location_off_rounded),
                                        onPressed: null)
                              ],
                            )
                          ],
                        ),
                      );
                    }))
            : Spinner();
      },
    );
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
      title: Text("Sorry!"),
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
