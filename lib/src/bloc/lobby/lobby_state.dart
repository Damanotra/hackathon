import 'package:flutter/cupertino.dart';

class LobbyState{
  final bool isLoading;
  final String errorMessage;
  final int contribution;
  final int points;
  final int minusPoints;
  final bool isSessionValid;

  LobbyState({
    this.isLoading,
    this.errorMessage,
    this.contribution,
    this.points,
    this.minusPoints,
    this.isSessionValid
  }){
    print("Lobby state created isloading "+this.isLoading.toString());
  }

  LobbyState copyWith({
    bool isLoading,
    String errorMessage,
    int contribution,
    int points,
    int minusPoints,
    bool isSessionValid,
  }) {
    return LobbyState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      contribution: contribution ?? this.contribution,
      points: points ?? this.points,
      minusPoints: minusPoints ?? this.minusPoints,
      isSessionValid: isSessionValid ?? this.isSessionValid
    );
  }

  factory LobbyState.initial() {
    return LobbyState(
      isLoading: true,
      errorMessage: null,
    );
  }

  LobbyState ready( contribution, points, minusPoints){
    return copyWith(
      isLoading: false,
      errorMessage: null,
      contribution: contribution,
      points: points,
      minusPoints: minusPoints,
      isSessionValid: true
    );
  }

  LobbyState loading(){
    return copyWith(
      isLoading: true,
      errorMessage: null
    );
  }

  LobbyState error(errorMessage){
    return copyWith(
        isLoading: false,
        errorMessage: errorMessage
    );
  }

  LobbyState relog(){
    return copyWith(
        isLoading: false,
        isSessionValid: false
    );
  }
}

