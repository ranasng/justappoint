import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:just_appoint/apiCall.dart';
import 'package:just_appoint/models/patient/clinicDetails.dart';
import 'package:just_appoint/models/patient/doctorLists.dart';
import 'package:just_appoint/models/patient/patientList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientApiProvider {
  ApiCall objApi = new ApiCall();
  SharedPreferences sharedPreferences;
  Future<PatientList> getPatientList() async {
    final jsonData = {};
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {"token": token};  
    try {
      String url = "patient/getaddedPatients.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {      
       final patientList = patientListFromMap(status.body);
        return patientList;
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      throw Exception('Failed to load Data');
    }
  }

   Future<List<DoctorLists>> getVerifiedDocData() async {
   sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {
      "token": token,
      "Content-Type": "application/json"
    };
    String data = "";
    var doctorList;
    ApiCall objApi = new ApiCall();
    try {
      String url = "patient/getDoctorLists.php";
      final status = await objApi.callPostMethod(data, url, requestHeaders);
      if (status.statusCode == 200) {
        //print(status.body);
        doctorList = doctorListsFromMap(status.body);
      }else{
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      //print(e.toString());
      debugPrint(e.toString());
      throw Exception('Failed to load Data');
    }
    return doctorList;
  }
   Future<List<ClinicDetailsModal>> getClinicDetails(String doctorId) async {
    //print(this.doctorId);
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    Map<String, String> requestHeaders = {
      "token": token,
      "Content-Type": "application/json"
    };

    final jsonData = {
      "doctor_id": doctorId,
    };
    var clinicDetailsModal;
    ApiCall objApi = new ApiCall();
    try {
      String url = "patient/getbookingClinicDetails.php";
      final status = await objApi.callPostMethod(
          jsonEncode(jsonData), url, requestHeaders);
      if (status.statusCode == 200) {
        //print(status.body);
        clinicDetailsModal = clinicDetailsModalFromMap(status.body);
      }else{
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load Data');
    }
    return clinicDetailsModal;
  }
}
