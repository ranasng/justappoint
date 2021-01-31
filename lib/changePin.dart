import 'package:flutter/material.dart';

import 'verifyMobile.dart';
class ChangePin extends StatefulWidget {
  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change PIN")),
      body: Container(
        child: VerifyMobile( title: "Verify Mobile Number",verificationType: "updatepin",
        )
         
        ),
      
    );
  }
}
