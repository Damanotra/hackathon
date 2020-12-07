import 'package:flutter/material.dart';

class LobbyEvent{
  final BuildContext context;
  LobbyEvent({this.context});
}

class InitialLobbyEvent extends LobbyEvent{
  InitialLobbyEvent({BuildContext context}): super(context:context);
  @override
  String toString() => "Initial LobbyEvent";
}

class InitialNoLoadingEvent extends LobbyEvent{
  final int contribution;
  final int points;
  final int minusPoints;
  InitialNoLoadingEvent({BuildContext context,this.contribution, this.points, this.minusPoints}): super(context:context);
  @override
  String toString() => "Initial LobbyEvent From Splash";
}