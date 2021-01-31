import 'package:flutter/material.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/blocs/patient/clinic_to_book_bloc.dart';
import 'package:just_appoint/blocs/patient/verified_doctor_bloc.dart';
import 'package:just_appoint/models/patient/doctorLists.dart';
import 'package:just_appoint/screen/doctor/widget/spinner.dart';
import 'package:just_appoint/screen/patient/clinicDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../drawerDesign.dart';
import '../splash.dart';

class PatientHomePage extends StatefulWidget {
  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final _docListBloc = DoctorListBloc();
  @override
  void initState() {
    _docListBloc.eventSink.add(DoctorListAction.Fetch);
    super.initState();
  }

  @override
  void dispose() {
    _docListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        drawer: LeftDrawer(),
        body: StreamBuilder(
          stream: _docListBloc.doclistStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text(snapshot.error ?? 'Error'));
            return snapshot.hasData
                ? Container(
                    margin: EdgeInsets.all(10),
                    child: listViewWidget(snapshot.data))
                : loader(6);
          },
        ));
  }

  logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }

  Widget listViewWidget(List<DoctorLists> doctorlist) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: doctorlist.length,
        itemBuilder: (context, position) {
          return InkWell(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "${doctorlist[position].doctorName}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: Row(
                      children: [
                        Text("${doctorlist[position].degreeName}"),
                        Text(", ${doctorlist[position].mdName}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                            "Speciality: ${doctorlist[position].specialityName}, "),
                        Text("Experience: ${doctorlist[position].experience}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: ClinicDetails(doctorlist[position].doctorId)));
            },
          );
        });
  }
}

Widget loader(int count) {
  return Container(
     margin: EdgeInsets.all(10),
    child: Column(
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: 40.0,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              itemCount: count,
            ),
          ),
        ),
      ],
    ),
  );
}
