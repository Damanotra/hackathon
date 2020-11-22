import 'package:flutter/material.dart';

class SplashEvent{
  final BuildContext context;
  SplashEvent({this.context});
}

class InitialSplashEvent extends SplashEvent{
  InitialSplashEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial SplashEvent";
}