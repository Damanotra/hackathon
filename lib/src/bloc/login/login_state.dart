import 'package:flutter/cupertino.dart';

class LoginState{
  bool isLoading;
  bool isSuccess;
  String errorMessage;

  LoginState({this.isLoading,this.isSuccess,this.errorMessage});

  LoginState copyWith({
    bool isLoading,
    bool isSuccess,
    String errorMessage,
  }) {
    return LoginState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory LoginState.initial() {
    return LoginState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
    );
  }

  LoginState ready(errorMessage){
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  LoginState loading(){
    return copyWith(
      isLoading: true
    );
  }

  LoginState success(){
    return copyWith(
      isLoading: false,
      isSuccess: true,
      errorMessage: null
    );
  }
}

