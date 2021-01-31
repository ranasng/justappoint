// To parse this JSON data, do
//
//     final mypatientList = mypatientListFromMap(jsonString);

import 'dart:convert';

List<MypatientList> mypatientListFromMap(String str) => List<MypatientList>.from(json.decode(str).map((x) => MypatientList.fromMap(x)));

class MypatientList {
    MypatientList({
        this.appointmentDate,
        this.appointmentId,
        this.patientId,
        this.userId,
        this.totalAmount,
        this.patientName,
        this.patientGender,
        this.patientDob,
    });

    DateTime appointmentDate;
    String appointmentId;
    String patientId;
    String userId;
    String totalAmount;
    String patientName;
    String patientGender;
    DateTime patientDob;

    factory MypatientList.fromMap(Map<String, dynamic> json) => MypatientList(
        appointmentDate: DateTime.parse(json["appointment_date"]),
        appointmentId: json["appointment_id"],
        patientId: json["patient_id"],
        userId: json["user_id"],
        totalAmount: json["total_amount"],
        patientName: json["patient_name"],
        patientGender: json["patient_gender"],
        patientDob: DateTime.parse(json["patient_dob"]),
    );

}
