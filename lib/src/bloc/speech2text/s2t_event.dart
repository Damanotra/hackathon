import 'package:flutter/cupertino.dart';

class S2TEvent {
  final BuildContext context;
  S2TEvent({this.context});
}

class InitialS2TEvent extends S2TEvent{
  InitialS2TEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial S2TEvent";
}

class SkipEvent extends S2TEvent{
  SkipEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Skip 1 voice";
}

class SubmitEvent extends S2TEvent{
  String annotation;
  SubmitEvent({BuildContext context, String annotation}): super(context:context);
  @override
  String toString() => "Submit Annotation";
}
