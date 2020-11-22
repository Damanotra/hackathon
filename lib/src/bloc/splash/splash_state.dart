import 'package:flutter/cupertino.dart';

class SplashState{
  bool isLoading;
  bool isSuccess;
  String errorMessage;

  SplashState({
    this.isLoading=true,
    this.isSuccess=false,
    this.errorMessage
  });

  SplashState copyWith({
    bool isLoading,
    bool isSuccess,
    String errorMessage,
  }) {
    return SplashState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        errorMessage: errorMessage ?? this.errorMessage,
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

  SplashState success(){
    return copyWith(
      isLoading: false,
      isSuccess: true,
      errorMessage: null
    );
  }
}

