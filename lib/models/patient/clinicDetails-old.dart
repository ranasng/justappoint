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
        this.schedule,
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
    List<Schedule> schedule;

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
        schedule: List<Schedule>.from(json["schedule"].map((x) => Schedule.fromMap(x))),
    );

   
}

class Schedule {
    Schedule({
        this.dayNo,
        this.dayName,
        this.startTime,
        this.endTime,
    });

    String dayNo;
    String dayName;
    String startTime;
    String endTime;

    factory Schedule.fromMap(Map<String, dynamic> json) => Schedule(
        dayNo: json["day_no"],
        dayName: json["day_name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
    );

  
}
