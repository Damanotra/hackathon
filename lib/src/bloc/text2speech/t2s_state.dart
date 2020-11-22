import 'package:flutter/cupertino.dart';

class T2SState{
  final List textList;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  final bool isNext;
  T2SState({
    @required this.textList,
    this.errorMessage,
    this.isLoading = true,
    this.isDone = false,
    this.isNext = false,
  });

  T2SState copyWith({
    List textList,
    String errorMessage,
    bool isLoading,
    bool isDone,
    bool isNext,
  }) {
    return T2SState(
      textList: textList ?? this.textList,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone,
      isNext: isNext ?? this.isNext
    );
  }

  factory T2SState.initial() {
    return T2SState(
      textList: [],
      isLoading: true,
      errorMessage: null,
      isDone: false,
      isNext: false
    );
  }

  T2SState ready(textList, textIndex,score){
    return copyWith(
      textList: textList,
      errorMessage: null,
      isLoading:false,
    );
  }

  T2SState loading(){
    return copyWith(
      isLoading: true,
      errorMessage: null,
    );
  }

  T2SState error(errorMessage){
    print("this is error message");
    print(errorMessage);
    return copyWith(
      errorMessage: errorMessage,
      isLoading: false,
    );
  }

  T2SState done(){
    return copyWith(
        isLoading: false,
        errorMessage: null,
        isDone: true
    );
  }

  T2SState next(){
    return copyWith(
        isLoading: true,
        errorMessage: null,
        isNext: true
    );
  }
}