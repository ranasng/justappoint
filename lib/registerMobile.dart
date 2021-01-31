import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'animate/slideRouter.dart';
import 'apiCall.dart';
import 'screen/createLoginPin.dart';
import 'screen/doctor/widget/spinner.dart';
import 'verifyMobile.dart';

class RegisterMobileNo extends StatefulWidget {
  @override
  _RegisterMobileNoState createState() => _RegisterMobileNoState();
}

class _RegisterMobileNoState extends State<RegisterMobileNo> {
  final _phoneController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
    @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Mobile Registration"),
        ),
        body: Container(
            child: VerifyMobile(
          title: "Verify Mobile Number",
          verificationType: "createpin",
        )));
  }
}
