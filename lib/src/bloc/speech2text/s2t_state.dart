import 'package:flutter/cupertino.dart';

class S2TState{
  final List voiceList;
  final int voiceIndex;
  final String localVoicePath;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  S2TState({
    @required this.voiceList,
    @required this.voiceIndex,
    @required this.localVoicePath,
    @required this.errorMessage,
    @required this.isLoading,
    this.isDone= false});

  S2TState copyWith({
    List voiceList,
    int voiceIndex,
    String localVoicePath,
    String errorMessage,
    bool isLoading,
    isDone
  }) {
    return S2TState(
      voiceList: voiceList ?? this.voiceList,
      voiceIndex: voiceIndex ?? this.voiceIndex,
      localVoicePath: localVoicePath ?? this.localVoicePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone : isDone ?? isDone
    );
  }

  factory S2TState.initial() {
    return S2TState(
      voiceList: [],
      voiceIndex: -1,
      localVoicePath:'',
      isLoading: true,
      errorMessage: null,
      isDone: false
    );
  }

  S2TState ready(voiceList,voiceIndex,localVoicePath){
    return copyWith(
      voiceList: voiceList,
      voiceIndex: voiceIndex,
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
      errorMessage: errorMessage
    );
  }
  S2TState done(){
    return copyWith(
      isLoading: false,
      errorMessage: null,
      isDone: true
    );
  }
}