import 'package:flutter/material.dart';
import 'package:hackathon/src/ui/screen/home.dart';
import 'package:hackathon/src/ui/screen/speech2text.dart';
import 'package:hackathon/src/ui/screen/text2speech.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/text':
        return MaterialPageRoute(
            builder: (_) => Text2Speech()
        );
      case '/speech':
        return MaterialPageRoute(
            builder: (_) => Speech2Text()
        );
    }
  }
}