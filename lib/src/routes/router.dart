import 'package:flutter/material.dart';
import 'package:hackathon/src/ui/screen/home.dart';
import 'package:hackathon/src/ui/screen/lobby.dart';
import 'package:hackathon/src/ui/screen/login.dart';
import 'package:hackathon/src/ui/screen/signup.dart';
import 'package:hackathon/src/ui/screen/speech2text.dart';
import 'package:hackathon/src/ui/screen/text2speech.dart';
import 'package:hackathon/src/ui/screen/validate.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => LobbyScreen(),
        );
      case '/text':
        return MaterialPageRoute(
            builder: (_) => Text2Speech()
        );
      case '/speech':
        return MaterialPageRoute(
            builder: (_) => Speech2Text()
        );
      case '/validate':
        return MaterialPageRoute(
            builder: (_) => ValidateScreen()
        );
      case '/signup':
        return MaterialPageRoute(
            builder: (_) => SignupScreen()
        );
      case '/login':
        return MaterialPageRoute(
            builder: (_) => LoginScreen()
        );
    }
  }
}