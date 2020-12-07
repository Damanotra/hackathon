import 'package:flutter/cupertino.dart';

class SplashState{
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final int contribution;
  final int points;
  final int minusPoints;

  SplashState( {
    this.isLoading=true,
    this.isSuccess=false,
    this.errorMessage,
    this.contribution,
    this.points,
    this.minusPoints,
  });

  SplashState copyWith({
    bool isLoading,
    bool isSuccess,
    String errorMessage,
    int contribution,
    int points,
    int minusPoints,
  }) {
    return SplashState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        errorMessage: errorMessage ?? this.errorMessage,
        contribution: contribution ?? this.contribution,
        points: points ?? this.points,
        minusPoints: minusPoints ?? this.minusPoints
    );
  }

  factory SplashState.initial() {
    return SplashState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
    );
  }

  SplashState ready(errorMessage){
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  SplashState loading(){
    return copyWith(
      isLoading: true,
      errorMessage: null
    );
  }

  SplashState success(contribution,points, minusPoints){
    return copyWith(
      isLoading: false,
      isSuccess: true,
      errorMessage: null,
      contribution: contribution,
      points: points,
      minusPoints: minusPoints
    );
  }
}

