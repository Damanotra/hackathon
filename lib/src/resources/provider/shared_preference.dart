
import 'dart:convert';

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

  List<dynamic> getGameList(){
    return json.decode(prefs.get('gameList'));
  }

  void setGameList(dynamic gameList) async {
    await prefs.setString('gameList', gameList.toString());
  }

  void addGameList(int value) async {
    final gameList = getGameList();
    gameList.add(value);
    setGameList(gameList);
  }

  void popGameList() async {
    final gameList = getGameList();
    gameList.removeAt(0);
    setGameList(gameList);
  }

  int getGameIndex(){
    return prefs.getInt('gameIndex');
  }

  void setGameIndex(int index) async{
    await prefs.setInt('gameIndex', index);
  }

  void nextGameIndex() async{
    setGameIndex(getGameIndex()+1);
  }

  int getGameScore(){
    return prefs.getInt('gameScore');
  }

  void setGameScore(int value)async{
    await prefs.setInt('gameScore', value);
  }

  void plusGameScore()async{
    setGameScore(getGameScore()+1);
  }

  void minusGameScore()async{
    if(getGameScore()>0)
      setGameScore(getGameScore()-1);
  }
}