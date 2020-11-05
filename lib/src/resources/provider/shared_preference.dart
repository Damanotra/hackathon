
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  SharedPreferences prefs;
  static Preference _instance;

  Preference({this.prefs});

  static Future<Preference> getInstance() async
  {
    if(_instance==null){
      final prefs = await SharedPreferences.getInstance();
      _instance = Preference(prefs: prefs);
    }
    return _instance;
  }

  String getSessionId(){
    print("get SESSIONID = ${prefs.getString('session')}");
    return prefs.getString('session');
  }

  void setSessionId(String session) async {
    print('SET SESSIONID = $session');
    await prefs.setString('session', session);
  }

  String getEmail(){
    return prefs.getString('email');
  }

  void setEmail(String email) async{
    print('SET EMAIL =$email');
    await prefs.setString('email', email);
  }

  String getPassword(){
    return prefs.get('password');
  }
  void setPassword(String password) async {
    await prefs.setString('password', password);
  }

  Future<void> logout() async {
    print("LOG OUT");
    await prefs.remove('session');
    await prefs.remove('email');
    await prefs.remove('password');
  }

}