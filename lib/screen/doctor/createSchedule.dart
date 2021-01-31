import 'package:flutter/material.dart';

import 'widget/scheduleAppointment.dart';

class CreateSchedule extends StatefulWidget {
  final String clinicName;
  final String clinicId; 
  CreateSchedule(this.clinicName,this.clinicId);
  @override
  _CreateScheduleState createState() => _CreateScheduleState(this.clinicName,this.clinicId);  
}

class _CreateScheduleState extends State<CreateSchedule> {
  final String clinicName;
  final String clinicId;
  _CreateScheduleState(this.clinicName,this.clinicId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Schedule"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text("Create Schedule For $clinicName",
            style: TextStyle(fontWeight:FontWeight.w500 ),
            ),
            ScheduleAppointment(clinicId: this.clinicId),
          ],
        )
      ),
    );
  }
}