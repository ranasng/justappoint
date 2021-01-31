import 'dart:convert';
import 'package:flutter/material.dart';
import '../apiCall.dart';
import '../tokenManager.dart';
import 'doctor/widget/spinner.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  ApiCall objApi = new ApiCall();
  bool isLoaded = false;
  String name = "",
      sex = "",
      email = "",
      mobile = "",
      mdIn = "",
      experience = "",
      mciNo = "",
      dob = "",
      degreeName = "",
      mdName = "",
      specialityName = "",
      token = "";
  TokenManager objToken = new TokenManager();
  @override
  void initState() {
    objToken.getToken().then((String tokenValue) {
      token = tokenValue;
      objToken.getEmailSession().then((String emailId) {
        email = emailId;
        getProfileData();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenHeight = MediaQuery.of(context).size.height;
    dynamic screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: isLoaded
            ? Container(              
                margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(
                  children: [
                    Container(
                      height: screenHeight / 2.5,                      
                      child: Card(
                        semanticContainer: true,
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Column(
                            children: [
                              Icon(
                                Icons.face,
                                size: 45,
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                email,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                height: screenwidth / 50,
                              ),
                              Text(
                                mobile,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                height: screenwidth / 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    degreeName,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: screenwidth / 30,
                                  ),
                                  Text(
                                    mdName,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenwidth / 50,
                              ),
                              Text(
                                specialityName,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(
                                height: screenwidth / 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    sex,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: screenwidth / 30,
                                  ),
                                  Text(
                                    "Dob:$dob",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenwidth / 50,
                              ),
                              Text(
                                "$experience Year Experience ",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Spinner());
  }

  getProfileData() async {
    final jsonData = {"email_id": email,"type":"email"};
    Map<String, String> requestHeaders = {"token": token,
    'Content-type': 'application/json'
    };
    try {
      var bytes = utf8.encode(jsonEncode(jsonData));
      String encodedStr = base64.encode(bytes);
      String url = "doctor/getDoctorProfile.php";
      final status =
          await objApi.callPostMethod(encodedStr, url, requestHeaders);
      if (status.statusCode == 200) {
        var decodedStr = base64.decode(status.body);
        var decodedJson = jsonDecode(utf8.decode(decodedStr));
        if (this.mounted) {
          setState(() {
            name = decodedJson['name'];
            sex = decodedJson['sex'];
            email = decodedJson['email_id'];
            dob = decodedJson['dob'];
            mdIn = decodedJson['md_in'];
            experience = decodedJson['experience'];
            mciNo = decodedJson['mci_no'];
            mobile = decodedJson['mobile_no'];
            degreeName = decodedJson['degree_name'];
            mdName = decodedJson['md_name'];
            specialityName = decodedJson['speciality_name'];
            isLoaded = true;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
