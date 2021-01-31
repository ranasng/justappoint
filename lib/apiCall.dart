import 'package:http/http.dart' as http;
class ApiCall{
  static String versionNo="1.0.2";
//final baseUrl="http://192.168.43.190/just_appoint/"; //local
//final baseUrl="http://192.168.44.162/just_appoint/"; //bluetooth local
final baseUrl="https://www.justappoint.com/api/test/justappoint/";
//final baseUrl="https://www.justappoint.com/api/justappoint/";
Future<http.Response> callPostMethod(final postData,String pageName, final headers) async {    
     final url=baseUrl+pageName;
    final postReqResponse = await http.post(
      url,  
      headers: headers,        
      body: postData,
    );    
    return postReqResponse;
  }
  Future<http.Response> callGetMethod(String pageName,final header) async {    
     final url=baseUrl+pageName;
    final getReqResponse = await http.get(
      url, headers: header
    );    
    return getReqResponse;
  }
 
  
}