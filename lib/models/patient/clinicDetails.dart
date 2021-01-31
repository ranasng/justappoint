// To parse this JSON data, do
//
//     final clinicDetailsModal = clinicDetailsModalFromMap(jsonString);

import 'dart:convert';

List<ClinicDetailsModal> clinicDetailsModalFromMap(String str) => List<ClinicDetailsModal>.from(json.decode(str).map((x) => ClinicDetailsModal.fromMap(x)));

class ClinicDetailsModal {
    ClinicDetailsModal({
        this.clinicId,
        this.clinicName,
        this.status,
        this.baseFee,
        this.maxPatient,
        this.stateId,
        this.address,
        this.cityId,
        this.latitude,
        this.longitude,
        this.stateName,
        this.cityName,
      this.iscoordinate,
        
    });

    String clinicId;
    String clinicName;
    String status;
    String baseFee;
    String maxPatient;
    String stateId;
    String address;
    String cityId;
    String latitude;
    String longitude;
    String stateName;
    String cityName;
    int iscoordinate;

    factory ClinicDetailsModal.fromMap(Map<String, dynamic> json) => ClinicDetailsModal(
        clinicId: json["clinic_id"],
        clinicName: json["clinic_name"],
        status:json["status"],
        baseFee: json["base_fee"],
        maxPatient: json["max_patient"],
        stateId: json["state_id"],
        address: json["address"],
        cityId: json["city_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        stateName: json["state_name"],
        cityName: json["city_name"],
        iscoordinate: json["iscoordinate"],
       
    );

   
}

