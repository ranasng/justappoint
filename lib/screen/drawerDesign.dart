import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/screen/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'patient/addnewPatient.dart';
import 'patient/myAppointments.dart';
import 'patient/patHome.dart';

class LeftDrawer extends StatelessWidget {
  String userName="",userEmail="";
  LeftDrawer(){
     this.setUserName();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            child: UserAccountsDrawerHeader(
              accountName: Text("$userName"),
              accountEmail: Text("$userEmail"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.orange
                        : Colors.white,
                child: Text(
                  "${userName[0]}",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home_outlined),
           
            onTap: () {
               Navigator.pushReplacement(
                  context,
                  SlideRightRoute(
                      page: PatientHomePage()));
            },
          ),
          ListTile(
            title: Text("Add Patient"),
            leading: Icon(Icons.supervised_user_circle),
           
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                  context,
                  SlideRightRoute(
                      page: AddnewPatient()));
            },
          ),
         /*  ListTile(
            title: Text("Appointments"),
            leading: Icon(Icons.supervised_user_circle),
           
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                  context,
                  SlideRightRoute(
                      page: Myappointments()));
            },
          ), */
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: () {              
             // Navigator.pop(context);
              showAlertDialog(context);
            },
          )
        ],
      ),
    );
  }

  logOut(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    {
      Navigator.pushReplacement(context, SlideRightRoute(page: SplashScreen()));
    }
  }

  void setUserName () async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userName=sharedPreferences.getString("firstName");
    userEmail= sharedPreferences.getString("emailId");
  }
  void showAlertDialog(BuildContext dialogContext) {
  showDialog(
    context: dialogContext,
    child:  CupertinoAlertDialog(
      title: Text("Log out?"),
      content: Text( "Are you sure you want to log out?"),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: (){
              Navigator.pop(dialogContext);
            },
            child: Text("Cancel")
        ),
        CupertinoDialogAction(
          textStyle: TextStyle(color: Colors.red),
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(dialogContext);
              /* SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('isLogin');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen())); */
                  logOut(dialogContext);
            },
            child: Text("Log out")
        ),
      ],
    ));
}
}
