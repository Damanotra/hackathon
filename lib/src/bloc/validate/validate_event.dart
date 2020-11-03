import 'package:flutter/cupertino.dart';

class ValidateEvent {
  final BuildContext context;
  ValidateEvent({this.context});
}

class InitialValidateEvent extends ValidateEvent{
  InitialValidateEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial ValidateEvent";
}

class SkipEvent extends ValidateEvent{
  SkipEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Skip 1 voice";
}

class SubmitEvent extends ValidateEvent{
  bool validation;
  SubmitEvent({BuildContext context, @required this.validation}): super(context:context);
  @override
  String toString() => "Submit Annotation";
}
