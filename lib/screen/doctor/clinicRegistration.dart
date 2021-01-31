import 'dart:convert';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/models/doctor/clinicList.dart';
import 'package:just_appoint/screen/graphics/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../apiCall.dart';
import '../../tokenManager.dart';
import 'addNewClinic.dart';
import 'widget/getScheduleData.dart';
import 'widget/spinner.dart';

class ClinicRegistration extends StatefulWidget {
  @override
  _ClinicRegistrationState createState() => _ClinicRegistrationState();
}

class _ClinicRegistrationState extends State<ClinicRegistration> {
  SharedPreferences sharedPreferences;
  ApiCall objApi = new ApiCall();
  TokenManager objToken = new TokenManager();
  String token = "";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: scaffoldKey,
      /* floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Clinic"),
        onPressed: () {
          Navigator.push(context, SlideRightRoute(page: AddnewClinic()));
        },
      ),*/
      body: FutureBuilder(
        future: getMyClinic(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? Container(
                      margin: EdgeInsets.only(left: 15),
                      child: listViewWidget(
                          snapshot.data, screenHeight, screenwidth))
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: screenHeight/50),
                            child: Text("Clinic Not Registered",
                            style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context, SlideRightRoute(page: AddnewClinic()));
                            },
                            child: Text(
                              "Register Your Clinic",
                            ),
                          )
                        ],
                      ),
                  )
              : Spinner();
        },
      ),
    );
  }

  Future<List<ClinicList>> getMyClinic() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      "token": sharedPreferences.getString("token")
    };

    var clinicList;
    try {
      //var bytes = utf8.encode(jsonEncode(jsonData));

      String encodedStr = "";
      String url = "doctor/getMyClinics.php";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        var decodedStr = base64.decode(status.body);
        var decodedJsonStr = utf8.decode(decodedStr);
        clinicList = clinicListFromMap(decodedJsonStr);
      }
    } catch (e) {
      print(e.toString());
    }
    return clinicList;
  }

  Widget listViewWidget(
      List<ClinicList> clinicList, var screenHeight, var screenWidth) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: clinicList.length,
        itemBuilder: (context, position) {
          return ListTileTheme(
            contentPadding: EdgeInsets.all(0),
            child: ExpansionTile(
              expandedAlignment: Alignment.topLeft,
              title: ListTile(
                title: Text(
                  "${clinicList[position].clinicName}",
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text("Max Patient: ${clinicList[position].maxPatient}"),
                        Text(" Fee: "),
                        Icon(
                          CustomIcons.rupee,
                          size: 16,
                          color: Colors.grey,
                        ),
                        Text("${clinicList[position].baseFee}"),
                        // Text(" ${clinicList[position].cityId}"),
                      ],
                    ),
                  ],
                ),
              ),
              children: [
                // ScheduleAppointment(switchVal: true,clinicId: clinicList[position].clinicId,),
                ScheduleDataget(
                  clinicId: clinicList[position].clinicId,
                  clinicName: clinicList[position].clinicName,
                ),
              ],
            ),
          );
        });
  }
}
