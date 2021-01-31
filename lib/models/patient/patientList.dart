// To parse this JSON data, do
//
//     final patientList = patientListFromMap(jsonString);

import 'dart:convert';

PatientList patientListFromMap(String str) => PatientList.fromMap(json.decode(str));
class PatientList {
    PatientList({
        this.patList,
    });

    List<PatList> patList;

    factory PatientList.fromMap(Map<String, dynamic> json) => PatientList(
        patList: List<PatList>.from(json["patList"].map((x) => PatList.fromMap(x))),
    );

}

class PatList {
    PatList({
        this.patientId,
        this.patientName,
        this.patientGender,
        this.patientDob,
    });

    String patientId;
    String patientName;
    String patientGender;
    String patientDob;

    factory PatList.fromMap(Map<String, dynamic> json) => PatList(
        patientId: json["patient_id"],
        patientName: json["patient_name"],
        patientGender: json["patient_gender"],
        patientDob: json["patient_dob"],
    );

}
