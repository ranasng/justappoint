import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:just_appoint/models/patient/doctorLists.dart';
import 'package:just_appoint/resource/patient_api_provider.dart';
enum DoctorListAction{Fetch,Delete}
class DoctorListBloc{
  final _stateStreamController = StreamController<List<DoctorLists>>();
  StreamSink<List<DoctorLists>> get _doclistSink => _stateStreamController.sink;
  Stream<List<DoctorLists>> get doclistStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<DoctorListAction>();
  StreamSink<DoctorListAction> get eventSink => _eventStreamController.sink;
  Stream<DoctorListAction> get _eventStream => _eventStreamController.stream;
DoctorListBloc(){
  PatientApiProvider responseData= PatientApiProvider();
  _eventStream.listen((event) async {
    if(event==DoctorListAction.Fetch){
      try {
        var doclist=await responseData.getVerifiedDocData();
        _doclistSink.add(doclist);
      } on Exception catch (e) {
        debugPrint(e.toString());
             _doclistSink.addError("Somthing Went Wrong");
      }
    }
  });
}
void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }
}