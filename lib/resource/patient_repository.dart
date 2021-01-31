import 'package:just_appoint/models/patient/patientList.dart';
import 'patient_api_provider.dart';

class PatientRepository {
  final patientApiProvider = PatientApiProvider();
  Future<PatientList> fetchAllPatients() => patientApiProvider.getPatientList();
}