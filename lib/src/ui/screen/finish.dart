import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

class FinishScreen extends StatefulWidget {
  @override
  _FinishScreenState createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  final _prefs = locator<Preference>();
  final random = locator<Random>();

  generateGameList() {
    if(_prefs.getGameMax()>0){
      _prefs.setGameList([]);
      print(_prefs.getGameMax());
      for (var i = 0; i < _prefs.getGameMax(); i++) {
        _prefs.addGameList(random.nextInt(3));
      }
      _prefs.setGameScore(0);
      print(_prefs.getGameList());
      print(_prefs.getGameScore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Text(
                "Selamat, task sudah selesai",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
            SizedBox(height: deviceHeight*0.15),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0),
                        textStyle: TextStyle()
                    ),
                    child: Container(
                        height: deviceHeight * 0.06,
                        width: deviceWidth * 0.37,
                        alignment: AlignmentDirectional.center,
                        child: Text("Ke Halaman Utama")),
                  ),
                  SizedBox(width: deviceWidth * 0.06),
                  ElevatedButton(
                    onPressed: () {
                      generateGameList();
                      switch(_prefs.getGameList()[0]){
                        case 0:
                          Navigator.of(context).pushReplacementNamed('/speech', arguments: (Route<dynamic> route) => false);
                          break;
                        case 1:
                          Navigator.of(context).pushReplacementNamed('/text', arguments: (Route<dynamic> route) => false);
                          break;
                        case 2:
                          Navigator.of(context).pushReplacementNamed('/validate', arguments: (Route<dynamic> route) => false);
                          break;
                }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0),
                        textStyle: TextStyle()),
                    child: Container(
                        height: deviceHeight * 0.06,
                        width: deviceWidth * 0.37,
                        alignment: AlignmentDirectional.center,
                        child: Text("Kerjakan Lagi")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
