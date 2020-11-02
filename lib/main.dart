import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon/src/app.dart';

import 'locator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await setupLocator();
  runApp(MyApp());
}


