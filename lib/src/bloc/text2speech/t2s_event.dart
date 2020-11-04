import 'package:flutter/cupertino.dart';

class T2SEvent {
  final BuildContext context;
  T2SEvent({this.context});
}

class InitialT2SEvent extends T2SEvent{
  InitialT2SEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial T2SEvent";
}

class SkipEvent extends T2SEvent{
  SkipEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Skip 1 voice";
}

class SubmitEvent extends T2SEvent{
  String text;
  String voicePath;
  SubmitEvent({BuildContext context, @required this.text, @required this.voicePath}): super(context:context);
  @override
  String toString() => "Submit Annotation";
}
