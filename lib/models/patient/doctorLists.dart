// To parse this JSON data, do
//
//     final doctorLists = doctorListsFromMap(jsonString);

import 'dart:convert';

List<DoctorLists> doctorListsFromMap(String str) => List<DoctorLists>.from(json.decode(str).map((x) => DoctorLists.fromMap(x)));

class DoctorLists {
    DoctorLists({
      this.doctorId,
        this.doctorName,
        this.degreeName,
        this.mdName,
        this.specialityIn,
        this.specialityName,
        this.experience,
        this.sex,
    });
String doctorId;
    String doctorName;
    String degreeName;
    String mdName;
    String specialityIn;
    String specialityName;
    String experience;
    String sex;

    factory DoctorLists.fromMap(Map<String, dynamic> json) => DoctorLists(
      doctorId:json["doc_id"],
        doctorName: json["doctor_name"],
        degreeName: json["degree_name"],
        mdName: json["md_name"],
        specialityIn: json["speciality_in"],
        specialityName: json["speciality_name"],
        experience: json["experience"],
        sex: json["sex"],
    );

}
