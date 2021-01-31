// To parse this JSON data, do
//
//     final clinicScheduleData = clinicScheduleDataFromMap(jsonString);

import 'dart:convert';

List<ClinicScheduleData> clinicScheduleDataFromMap(String str) => List<ClinicScheduleData>.from(json.decode(str).map((x) => ClinicScheduleData.fromMap(x)));

String clinicScheduleDataToMap(List<ClinicScheduleData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ClinicScheduleData {
    ClinicScheduleData({
        this.docId,
        this.clinicId,
        this.dayNo,
        this.dayName,
        this.startTime,
        this.endTime,
    });

    String docId;
    String clinicId;
    String dayNo;
    String dayName;
    String startTime;
    String endTime;

    factory ClinicScheduleData.fromMap(Map<String, dynamic> json) => ClinicScheduleData(
        docId: json["doc_id"],
        clinicId: json["clinic_id"],
        dayNo: json["day_no"],
        dayName: json["day_name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
    );

    Map<String, dynamic> toMap() => {
        "doc_id": docId,
        "clinic_id": clinicId,
        "day_no": dayNo,
        "day_name": dayName,
        "start_time": startTime,
        "end_time": endTime,
    };
}
