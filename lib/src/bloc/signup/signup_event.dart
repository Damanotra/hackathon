import 'package:flutter/material.dart';

class SignupEvent{
  final BuildContext context;
  SignupEvent({this.context});
}

class InitialSignupEvent extends SignupEvent{
  InitialSignupEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial SignupEvent";
}

class SubmitEvent extends SignupEvent{
  String email;
  String password;
  SubmitEvent({BuildContext context, @required this.email,@required this.password}):super(context: context);
  @override
  String toString() => "Submit Signup";
}