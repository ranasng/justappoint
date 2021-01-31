import 'package:just_appoint/models/patient/patientList.dart';
import 'package:just_appoint/resource/patient_repository.dart';
import 'package:rxdart/rxdart.dart';

class SelectpatientBloc {
   final _repositoryPatient = PatientRepository();
  final _patListFetcher = PublishSubject<PatientList>();
   Stream<PatientList> get allPatients => _patListFetcher.stream;
   fetchAllPatients() async {
    PatientList patientModel = await _repositoryPatient.fetchAllPatients();
    _patListFetcher.sink.add(patientModel);
  }
  dispose() {
    _patListFetcher.close();
  }
}
final selectPatbloc = SelectpatientBloc();