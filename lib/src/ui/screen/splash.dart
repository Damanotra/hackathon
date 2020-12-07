import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/src/bloc/splash/splash_bloc.dart';
import 'package:hackathon/src/bloc/splash/splash_event.dart';
import 'package:hackathon/src/bloc/splash/splash_state.dart';
import 'package:hackathon/src/routes/router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _splashBloc = SplashBloc();
  @override
  void initState() {
    // TODO: implement initState
    _splashBloc.add(InitialSplashEvent());
    super.initState();
//    Timer(
//        Duration(milliseconds: 2000),
//            (){
//          SystemChannels.textInput.invokeMethod('TextInput.hide');
//          Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
//        }
//    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc,SplashState>(
      cubit: _splashBloc,
      listener: (context,state){
        if(!state.isLoading){
          if(state.isSuccess){
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                 (Route<dynamic> route) => false,
              arguments: LobbyArguments(
                needLoading: false,
                contribution: state.contribution,
                points: state.points,
                minusPoints: state.minusPoints
              )
            );
          }
          else{
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          }
        }
      },
      child: Scaffold(
        body: Container(
          child: Center(child: Image.asset("assets/logo.jpg")),
        ),
      ),
    );
  }
}