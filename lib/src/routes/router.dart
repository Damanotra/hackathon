import 'package:flutter/material.dart';
import 'package:hackathon/src/ui/screen/finish.dart';
import 'package:hackathon/src/ui/screen/home.dart';
import 'package:hackathon/src/ui/screen/lobby.dart';
import 'package:hackathon/src/ui/screen/login.dart';
import 'package:hackathon/src/ui/screen/signup.dart';
import 'package:hackathon/src/ui/screen/speech2text.dart';
import 'package:hackathon/src/ui/screen/splash.dart';
import 'package:hackathon/src/ui/screen/text2speech.dart';
import 'package:hackathon/src/ui/screen/validate.dart';

class LobbyArguments{
  final bool needLoading;
  final int contribution;
  final int points;
  final int minusPoints;
  LobbyArguments({this.needLoading=true,this.contribution, this.points, this.minusPoints});
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        print("Splashscreen");
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/home':
        print("Lobbyscreen");
        LobbyArguments args;
        if(settings.arguments!=null){
          args = settings.arguments;
        } else{
          args = LobbyArguments();
        }
        return MaterialPageRoute(
          builder: (context) => LobbyScreen(
            needLoading: args.needLoading,
            contribution: args.contribution,
            points: args.points,
            minusPoints: args.minusPoints,
          ),
        );
      case '/text':
        print("text2speech screen");
        return MaterialPageRoute(
            builder: (_) => Text2Speech()
        );
      case '/speech':
        print("speech2text screen");
        return MaterialPageRoute(
            builder: (_) => Speech2Text()
        );
      case '/validate':
        print("validate screen");
        return MaterialPageRoute(
            builder: (_) => ValidateScreen()
        );
      case '/signup':
        print("signup screen");
        return MaterialPageRoute(
            builder: (_) => SignupScreen()
        );
      case '/login':
        print("login screen");
        return MaterialPageRoute(
            builder: (_) => LoginScreen()
        );
      case '/finish':
        print("finish screen");
        return MaterialPageRoute(
            builder: (_) => FinishScreen()
        );
    }
  }
}