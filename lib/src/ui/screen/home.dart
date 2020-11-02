import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          icon: Icon(Icons.menu,color: Colors.blue),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          }
        ),
      ),
      drawer: Drawer(),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.05),
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/speech', arguments: (Route<dynamic> route) => false);
              },
              child: Container(
                height: deviceHeight*0.2,
                margin: EdgeInsets.symmetric(vertical: deviceHeight*0.01),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 5
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Center(child: Text("Speech to Text")),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/text', arguments: (Route<dynamic> route) => false);
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
                child: Center(child: Text("Text to Speech")),
              ),
            ),
            Container(
              height: deviceHeight*0.2,
              margin: EdgeInsets.symmetric(vertical: deviceHeight*0.01),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.green,
                      width: 5
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Center(child: Text("Validation")),
            ),
          ],
        ),
      ),
    );
  }
}
