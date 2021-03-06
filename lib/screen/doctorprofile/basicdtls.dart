import 'package:just_appoint/animate/slideRouter.dart';
import 'package:just_appoint/screen/graphics/custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokenManager.dart';
import 'educationdtls.dart';

class BasicDetails extends StatefulWidget {
  @override
  _BasicDetailsState createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  var basicFormKey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController mname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  bool maleClicked = false, femaleClicke = false, buttonClicked=false;
   Future<bool> isLogged;
  TokenManager objToken=new TokenManager();
   DateTime dateTime = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLogged=objToken.userisLogged();
  }
  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic Details"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: basicFormKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: fname,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter First Name";
                  }
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: mname,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                ],
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: 'Middle Name (optional)',
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: lname,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter Last Name";
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.arrow_right),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: email,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(
                      RegExp("[A-Za-z0-9.@_-]"))
                ],
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Enter Email Id";
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Email Id',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Gender :",
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.1 / 2),
                      child: GestureDetector(
                        child: Container(
                          height: screenHeight * 0.2 / 3,
                          width: screenwidth * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: maleClicked
                                ? Color(0xff08838B)
                                : Colors.grey[350],
                          ),
                          //padding: EdgeInsets.fromLTRB(30, 17, 30, 17),
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.male,
                                color:
                                    maleClicked ? Colors.white : Colors.black,
                              ),
                              SizedBox(
                                width: screenwidth * 0.1 / 9,
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                    color: maleClicked
                                        ? Colors.white
                                        : Colors.black),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (maleClicked == false) {
                              maleClicked = true;
                              femaleClicke = false;
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: screenwidth * 0.1 / 2),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: femaleClicke
                                ? Color(0xff08838B)
                                : Colors.grey[350],
                          ),
                          padding: EdgeInsets.only(left: 20),
                          height: screenHeight * 0.2 / 3,
                          width: screenwidth * 0.3,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.female,
                                color:
                                    femaleClicke ? Colors.white : Colors.black,
                              ),
                              SizedBox(
                                width: screenwidth * 0.1 / 9,
                              ),
                              Text(
                                "Female",
                                style: TextStyle(
                                    color: femaleClicke
                                        ? Colors.white
                                        : Colors.black),
                              )
                            ],
                          ),
                          
                        ),
                        onTap: () {
                          setState(() {
                            if (femaleClicke == false) {
                              femaleClicke = true;
                              maleClicked = false;
                            }
                          });
                        },
                      ),
                      
                    )
                  ],
                ),
              ),
            buttonClicked ?  maleClicked==femaleClicke ? Text("Please Select Gender",
              style: TextStyle(color: Colors.red[800]),
              ) : SizedBox() : SizedBox(),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: dob,
                readOnly: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Please Select Date of Borth";
                  }
                },
                onTap: () {
                  /* showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height: screenHeight / 3, child: showCallender());
                      }); */
                      showCallender();
                },
                decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () async{
                
                  var retData = bindaData();
                  setState(() {
                    buttonClicked=true;
                    if (basicFormKey.currentState.validate()) {
                      Navigator.push(context,
                          SlideRightRoute(page: EducationDetls(retData)));
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Next",
                      ),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /* Widget showCallender() {
    var currentDate = DateTime.now();
    var maxYear = currentDate.year;
    var minYear = currentDate.year - 80;
    return CupertinoDatePicker(
      initialDateTime: currentDate,
      onDateTimeChanged: (DateTime newdate) {
        //print(newdate);
        dob.text = newdate.day.toString().padLeft(2, "0") +
            "-" +
            newdate.month.toString().padLeft(2, "0") +
            "-" +
            newdate.year.toString();
      },
      maximumDate: new DateTime(maxYear, 12, 31),
      minimumYear: minYear,
      maximumYear: maxYear,
      mode: CupertinoDatePickerMode.date,
    );
  } */
  showCallender() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(dateTime.year - 100),
        lastDate: DateTime(dateTime.year, dateTime.month, dateTime.day));
    if (picked != null && picked != dateTime)
      setState(() {
        dateTime = picked;
        dob.text = formatDatetime(dateTime.toString());
      });
  }

  bindaData() {
    String gender = "";
    if (maleClicked) {
      gender = "Male";
    } else if (femaleClicke) {
      gender = "Female";
    }
    var finalRecord = new Map();
    finalRecord['initial'] = "Dr.";
    finalRecord['fname'] = fname.text;
    finalRecord['mname'] = mname.text;
    finalRecord['lname'] = lname.text;
    finalRecord['emailid'] = email.text;
    finalRecord['gender'] = gender;
    finalRecord['dob'] = dob.text;
    return finalRecord;
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
