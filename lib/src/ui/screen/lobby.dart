import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/lobby/lobby_bloc.dart';
import 'package:hackathon/src/bloc/lobby/lobby_event.dart';
import 'package:hackathon/src/bloc/lobby/lobby_state.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

final _prefs = locator<Preference>();

class LobbyScreen extends StatefulWidget {
  final bool needLoading;
  final int contribution;
  final int points;
  final int minusPoints;
  const LobbyScreen({
    Key key,
    this.needLoading = true,
    this.contribution,
    this.points,
    this.minusPoints,
  }) : super(key: key);

  @override
  _LobbyScreenState createState() {
    if(_prefs.getGameMax()==null){
      _prefs.setGameMax(10);
    }
    return _LobbyScreenState();
  }
}

class _LobbyScreenState extends State<LobbyScreen> {
  final _lobbyBloc = LobbyBloc();
  final random = locator<Random>();
  final _maxScoreController = TextEditingController();

  @override
  void initState() {
//    if(widget.needLoading){
//      _lobbyBloc.add(InitialLobbyEvent());
//    }else{
//      _lobbyBloc.add(InitialNoLoadingEvent(contribution: widget.contribution,points: widget.points,minusPoints: widget.minusPoints));
//    }
    _lobbyBloc.add(InitialLobbyEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F8F9),
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.red),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
      drawer: Drawer(
          child: BlocListener<LobbyBloc, LobbyState>(
        cubit: _lobbyBloc,
        listener: (context, state) {
          if (!state.isLoading) {
            if (!state.isSessionValid) {
              // ini ngapain
//              Navigator.of(context).pushNamedAndRemoveUntil(
//                  '/home', (Route<dynamic> route) => false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            }
          }
        },
        child: BlocBuilder<LobbyBloc, LobbyState>(
            cubit: _lobbyBloc,
            builder: (context, state) {
              if (!state.isLoading) {
                if (state.errorMessage == null) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(_prefs.getEmail()),
                        accountEmail: null,
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("User Contributions"),
                            Text(state.contribution.toString())
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("User Points"),
                            Text(state.points.toString())
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("User Minus Point"),
                            Text(state.minusPoints.toString())
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Set Max Score"),
                            Text(_prefs.getGameMax().toString())
                          ],
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                _maxScoreController.text = "";
                                return AlertDialog(
                                  title: Text('Set Max Score'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _maxScoreController,
                                    decoration: InputDecoration(
                                        hintText:
                                            "current: ${_prefs.getGameMax()}"),
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          if (_maxScoreController.text != '') {
                                            final value = int.tryParse(_maxScoreController.text);
                                            if(value!=null){
                                              _prefs.setGameMax(value);
                                              print(_prefs.getGameMax());
                                              Navigator.of(context).pop();
                                            }
                                          }
                                        },
                                        child: Text("SUBMIT"))
                                  ],
                                );
                              });
                        },
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Panduan"),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Panduan'),
                                  content: ListView(
                                    children: [
                                      Container(
                                          height: deviceHeight * 0.5,
                                          child:
                                              Image.asset("assets/drawer.jpg")),
                                      Container(
                                          padding: EdgeInsets.only(bottom: 12),
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: Text(
                                              "Sebelum memulai game, kamu bisa menentukan maximum score di menu set max score, akses menu di tombol kiri atas lobby")),
                                      Container(
                                          height: deviceHeight * 0.5,
                                          child:
                                              Image.asset("assets/home.jpg")),
                                      Container(
                                          padding: EdgeInsets.only(bottom: 12),
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: Text(
                                              "Kembali ke lobby dan klik tombol di tengah untuk memulai task. Ada 3 jenis task dan kamu akan mendapatkan task secara random")),
                                      Container(
                                          height: deviceHeight * 0.5,
                                          child: Image.asset("assets/s2t.jpg")),
                                      Container(
                                          padding: EdgeInsets.only(bottom: 12),
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: Text(
                                              "Task jenis pertama adalah speech to text, di mana kamu akan diminta menulis apa yang diucapkan pembicara di rekaman yang diberikan. Kamu jika kamu sudah mengetik jawaba, tekan submit untuk mengirim jawabanmu, atau skip jika kamu ingin mencoba task selanjutnya")),
                                      Container(
                                          height: deviceHeight * 0.5,
                                          child: Image.asset("assets/t2s.jpg")),
                                      Container(
                                          padding: EdgeInsets.only(bottom: 12),
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: Text(
                                              "Task jenis kedua adalah text to speech, di mana giliran kamu membuat rekaman dengan mengucapkan kalimat sesuai yang muncul di bagian atas layar. Tekan icon mic untuk mulai merekam dan icon stop untuk berhenti merekam. Jika remakan telah dibuat, akan muncul icon-icon untuk memutar ulang rekamanmu sebelum akhirnya kamu kirim.")),
                                      Container(
                                          height: deviceHeight * 0.5,
                                          child: Image.asset(
                                              "assets/validate.jpg")),
                                      Container(
                                          padding: EdgeInsets.only(bottom: 12),
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: Text(
                                              "Task jenis ketiga adalah validate, di mana kamu diminta memvalidasi apakah rekaman dan text sudah sesuai. Tekan correct jika benar dan wrong jika salah")),
                                      Container(
                                          height: deviceHeight * 0.5,
                                          child:
                                              Image.asset("assets/score.jpg")),
                                      Container(
                                          padding: EdgeInsets.only(bottom: 12),
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border(bottom: BorderSide())),
                                          child: Text(
                                              "Untuk tiap task yang kamu kerjakan dengan benar kamu akan mendapatkan point. Kamu juga mungkin mendapatkan minus point jika kamu mengerjakan dengan tidak benar. Jika pointnya sudah mencapai maximum score yang kamu set sebelum mulai bermain, maka sesi pengerjaan task selesai")),
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Tutup"))
                                  ],
                                );
                              });
                        },
                      ),
                      ListTile(
                        title: Text("Log out"),
                        onTap: () {
                          _prefs.logout();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text("Something Gone Wrong"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      )),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: () async {
                generateGameList();
                switch (_prefs.getGameList()[0]) {
                  case 0:
                    await Navigator.of(context).pushNamed('/speech',
                        arguments: (Route<dynamic> route) => false);
                    break;
                  case 1:
                    await Navigator.of(context).pushNamed('/text',
                        arguments: (Route<dynamic> route) => false);
                    break;
                  case 2:
                    await Navigator.of(context).pushNamed('/validate',
                        arguments: (Route<dynamic> route) => false);
                    break;
                }
                _lobbyBloc.add(InitialLobbyEvent());
                print("Lobby refreshed");
              },
              child: Container(
                height: deviceHeight * 0.55,
                margin: EdgeInsets.symmetric(
                    vertical: deviceHeight * 0.01,
                    horizontal: deviceWidth * 0.02),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: Offset(5, 5))
                    ]),
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.asset("assets/slicered.png"),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    18), //Theme.of(context).textTheme.bodyText1,
                            children: [
                              TextSpan(text: "Annotate Speech"),
                              WidgetSpan(
                                  child: Icon(Icons.compare_arrows_sharp)),
                              TextSpan(text: "Text")
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}
