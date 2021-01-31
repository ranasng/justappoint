import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:just_appoint/models/patient/clinicDetails.dart';
import 'package:just_appoint/resource/patient_api_provider.dart';

enum ClinicListAction { FetchClinicByDoctor }

class ClinictobookBloc {
  String  docId;
  final _stateStreamController = StreamController<List<ClinicDetailsModal>>();
  StreamSink<List<ClinicDetailsModal>> get _clinicListSink =>
      _stateStreamController.sink;
  Stream<List<ClinicDetailsModal>> get clinicListStream =>
      _stateStreamController.stream;
  final _eventStreamController = StreamController<ClinicListAction>();
  StreamSink<ClinicListAction> get eventSink => _eventStreamController.sink;
  Stream<ClinicListAction> get _eventStream => _eventStreamController.stream;

  ClinictobookBloc() {
    PatientApiProvider responseData = PatientApiProvider();
    _eventStream.listen((event) async {
      if (event == ClinicListAction.FetchClinicByDoctor) {
        try {
          var clinicList = await responseData.getClinicDetails(docId);
          _clinicListSink.add((clinicList));
        } on Exception catch (e) {
          _clinicListSink.addError("Clinic Not Registered");
          debugPrint(e.toString());
        }
      }
    }
    );
  }
  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
