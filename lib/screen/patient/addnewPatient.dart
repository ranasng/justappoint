import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiCall.dart';

class AddnewPatient extends StatefulWidget {
  @override
  _AddnewPatientState createState() => _AddnewPatientState();
}

enum GenderData { male, female, transgender }

class _AddnewPatientState extends State<AddnewPatient> {
  var patientFormKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  TextEditingController patientName = TextEditingController();
  TextEditingController dateofBirth = TextEditingController();
  GenderData gender = GenderData.male;
  bool issaveClicked=false;
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Patient"),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: patientFormKey,
          child: ListView(
            children: [
              TextFormField(
                controller: patientName,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z ]")),
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter Patient's Name";
                  }
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: "Patient's Name",
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: dateofBirth,
                  readOnly: true,
                  onTap: () {
                    showCallender();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please Enter Patient's DOB";
                    }
                  },
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      labelText: "Patient's Date of Birth",
                      prefixIcon: Icon(Icons.arrow_right),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Male'),
                      leading: Radio(
                        value: GenderData.male,
                        groupValue: gender,
                        onChanged: (GenderData value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Female'),
                      leading: Radio(
                        value: GenderData.female,
                        groupValue: gender,
                        onChanged: (GenderData value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: issaveClicked ? null :() {
                  setState(() {
                    if (patientFormKey.currentState.validate()) {
                      issaveClicked=true;
                      savepatientData();
                    }
                  });
                },
                child: Text("Add Patient"),
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  savepatientData() async {
    final jsonData = {
      "patient_name": patientName.text,
      "patient_sex": gender.toString().split('.').last,
      "patient_dob": dateofBirth.text
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {"token": token};
    // print(jsonEncode(jsonData));
    try {
      ApiCall objApi = new ApiCall();
      String url = "patient/addnewpatient.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        var decodedStr = jsonDecode(status.body);
        if (decodedStr['status'] == 1) {
          showAlertDialog(context, "New Patient added Successfully");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showAlertDialog(BuildContext context, String msg) {
    // set up the buttons
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        patientName.clear();
        dateofBirth.clear();
        
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Message"),
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

  showCallender() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(dateTime.year - 100),
        lastDate: DateTime(dateTime.year, dateTime.month, dateTime.day));
    if (picked != null && picked != dateTime)
      setState(() {
        dateTime = picked;
        dateofBirth.text = formatDatetime(dateTime.toString());
      });
  }

  String formatDatetime(String date) {
    var parsedDate = DateTime.parse(date);
    String formatted = parsedDate.day.toString().padLeft(2, '0') +
        "-" +
        parsedDate.month.toString().padLeft(2, '0') +
        "-" +
        parsedDate.year.toString();

    return formatted;
  }
}
