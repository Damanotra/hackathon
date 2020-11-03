import 'package:flutter/material.dart';

class LoginEvent{
  final BuildContext context;
  LoginEvent({this.context});
}

class InitialLoginEvent extends LoginEvent{
  InitialLoginEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial LoginEvent";
}

class SubmitEvent extends LoginEvent{
  String email;
  String password;
  SubmitEvent({BuildContext context, @required this.email,@required this.password}):super(context: context);
  @override
  String toString() => "Submit Login";
}