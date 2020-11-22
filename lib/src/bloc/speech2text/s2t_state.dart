import 'package:flutter/cupertino.dart';

class S2TState{
  final List voiceList;
  final String localVoicePath;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  final bool isNext;
  S2TState({
    @required this.voiceList,
    @required this.localVoicePath,
    this.errorMessage,
    @required this.isLoading,
    this.isDone= false,
    this.isNext = false,
  });

  S2TState copyWith({
    List voiceList,
    String localVoicePath,
    String errorMessage,
    bool isLoading,
    isDone,
    isNext,
  }) {
    return S2TState(
      voiceList: voiceList ?? this.voiceList,
      localVoicePath: localVoicePath ?? this.localVoicePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone : isDone ?? this.isDone,
      isNext: isNext ?? this.isNext
    );
  }

  factory S2TState.initial() {
    return S2TState(
      voiceList: [],
      localVoicePath:'',
      isLoading: true,
      errorMessage: null,
      isDone: false,
      isNext: false
    );
  }

  S2TState ready(voiceList,voiceIndex,localVoicePath,score){
    return copyWith(
      voiceList: voiceList,
      localVoicePath: localVoicePath,
      errorMessage: null,
      isLoading:false,
    );
  }

  S2TState loading(){
    return copyWith(
      isLoading: true,
      errorMessage: null,
    );
  }

  S2TState error(errorMessage){
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  S2TState done(){
    return copyWith(
      isLoading: false,
      errorMessage: null,
      isDone: true,
    );
  }

  S2TState next(){
    return copyWith(
      isLoading: true,
      errorMessage: null,
      isNext: true
    );
  }
}