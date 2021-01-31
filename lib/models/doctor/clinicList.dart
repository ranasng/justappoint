// To parse this JSON data, do
//
//     final clinicList = clinicListFromMap(jsonString);

import 'dart:convert';
List<ClinicList> clinicListFromMap(String str) => List<ClinicList>.from(json.decode(str).map((x) => ClinicList.fromMap(x)));

class ClinicList {
    ClinicList({
        this.clinicId,
        this.docId,
        this.clinicName,
        this.baseFee,
        this.maxPatient,
        this.address,
        this.stateId,
        this.cityId,
        this.latitude,
        this.longitude,
        this.status,
        this.isDeleted,
        this.entryDate,
    });

    String clinicId;
    String docId;
    String clinicName;
    String baseFee;
    String maxPatient;
    String address;
    String stateId;
    String cityId;
    String latitude;
    String longitude;
    String status;
    String isDeleted;
    DateTime entryDate;

    factory ClinicList.fromMap(Map<String, dynamic> json) => ClinicList(
        clinicId: json["clinic_id"],
        docId: json["doc_id"],
        clinicName: json["clinic_name"],
        baseFee: json["base_fee"],
        maxPatient: json["max_patient"],
        address: json["address"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        entryDate: DateTime.parse(json["entry_date"]),
    );

   
}
