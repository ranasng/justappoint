// To parse this JSON data, do
//
//     final myappointment = myappointmentFromMap(jsonString);

import 'dart:convert';
List<Myappointment> myappointmentFromMap(String str) => List<Myappointment>.from(json.decode(str).map((x) => Myappointment.fromMap(x)));
class Myappointment {
    Myappointment({
        this.appointmentDate,
        this.appointmentId,
        this.patientId,
        this.userId,
        this.totalAmount,
        this.patientName,
        this.patientGender,
        this.patientDob,
        this.doctorName,
    });

    DateTime appointmentDate;
    String appointmentId;
    String patientId;
    String userId;
    String totalAmount;
    String patientName;
    String patientGender;
    DateTime patientDob;
    String doctorName;

    factory Myappointment.fromMap(Map<String, dynamic> json) => Myappointment(
        appointmentDate: DateTime.parse(json["appointment_date"]),
        appointmentId: json["appointment_id"],
        patientId: json["patient_id"],
        userId: json["user_id"],
        totalAmount: json["total_amount"],
        patientName: json["patient_name"],
        patientGender: json["patient_gender"],
        patientDob: DateTime.parse(json["patient_dob"]),
        doctorName: json["doctor_name"],
    );

  
}
