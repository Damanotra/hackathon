import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

final _prefs = locator<Preference>();
class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() {
    _prefs.setGameMax(10);
    return _LobbyScreenState();
  }
}

class _LobbyScreenState extends State<LobbyScreen> {

  final random = locator<Random>();
  final _maxScoreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.menu,color: Colors.red),
            onPressed: (){
              _scaffoldKey.currentState.openDrawer();
            }
        ),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.red
                ),
              ),
              ListTile(
                title: Text("Log out"),
                onTap: (){
                  _prefs.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                },
              )
            ],
          )
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.05),
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: (){
                generateGameList();
                switch(_prefs.getGameList()[0]){
                  case 0:
                    Navigator.of(context).pushNamed('/speech', arguments: (Route<dynamic> route) => false);
                    break;
                  case 1:
                    Navigator.of(context).pushNamed('/text', arguments: (Route<dynamic> route) => false);
                    break;
                  case 2:
                    Navigator.of(context).pushNamed('/validate', arguments: (Route<dynamic> route) => false);
                    break;
                }
//                Navigator.of(context).pushNamed('/speech', arguments: (Route<dynamic> route) => false);
              },
              child: Container(
                height: deviceHeight*0.2,
                margin: EdgeInsets.symmetric(vertical: deviceHeight*0.01),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.red,
                        width: 5
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Center(
                    child: Text("Game On",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text('Set Max Score'),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        controller: _maxScoreController,
                        decoration: InputDecoration(hintText: "current: ${_prefs.getGameMax()}"),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: (){
                            if(_maxScoreController.text!=''){
                              _prefs.setGameMax(int.parse(_maxScoreController.text));
                              print(_prefs.getGameMax());
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text("SUBMIT"))
                      ],
                    );
                  }
                );
              },
              child: Container(
                height: deviceHeight*0.2,
                margin: EdgeInsets.symmetric(vertical: deviceHeight*0.01),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.red,
                        width: 5
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Center(
                    child: Text("Settings",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
            GestureDetector(
              onTap: (){
                _prefs.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
              child: Container(
                height: deviceHeight*0.2,
                margin: EdgeInsets.symmetric(vertical: deviceHeight*0.01),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.red,
                        width: 5
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Center(
                    child: Text("Log Out",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  generateGameList() {
    _prefs.setGameList([]);
    print(_prefs.getGameMax());
    for(var i=0;i<_prefs.getGameMax();i++){
      _prefs.addGameList(random.nextInt(3));
    }
    _prefs.setGameScore(0);
    print(_prefs.getGameList());
    print(_prefs.getGameScore());
  }
}
