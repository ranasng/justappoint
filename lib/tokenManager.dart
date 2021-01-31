import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  SharedPreferences sharedPreferences;

  createLoginSession(bool isLogged, String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogged", isLogged);
    sharedPreferences.setString("token", token);
  }

  setProfileSession(bool status,String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isProfile", status);
    sharedPreferences.setString("firstName", name);
  }
  Future<String> getFirstname() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("firstName");
  }

  setEmailSession(String emailId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("emailId", emailId);
  }
  setDefaultClinicSession(String defaultClinicId)async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("default_clinic_id", defaultClinicId);
  }

  Future<String>getEmailSession() async {
    sharedPreferences = await SharedPreferences.getInstance();    
    return sharedPreferences.getString("emailId");
  }

  Future<bool> userisLogged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isLogged = sharedPreferences.getBool('isLogged') ?? false;
    return isLogged;
  }

  Future<bool> isUserProfileCreated() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isProfile = sharedPreferences.getBool('isProfile') ?? false;
    return isProfile;
  }

  Future<String> getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token') ?? '';
    return token;
  }
}
