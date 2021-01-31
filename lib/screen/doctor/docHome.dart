import 'package:just_appoint/screen/graphics/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'clinicRegistration.dart';
import '../viewProfile.dart';
import 'myPatients.dart';
import 'settings.dart';

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Home"),
         
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
           
            new Tab(
              icon: new Icon(CustomIcons.stethoscope),
              text: "My Clinic",
            ),
            
            new Tab(
              icon: new Icon(Icons.airline_seat_flat_angled),
              text: "Patients",
            ),
             new Tab(
              icon: new Icon(Icons.face),
              text: "Profile",
            ),
            new Tab(
              icon: new Icon(Icons.settings_applications),
              text: "Settings",
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [          
          ClinicRegistration(),          
          Mypatients(),
          ViewProfile(),
          Settings()
        ],
        controller: _tabController,
      ),
    );
  }
 
}
