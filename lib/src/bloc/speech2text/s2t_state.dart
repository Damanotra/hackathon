import 'package:flutter/cupertino.dart';

class S2TState{
  final List voiceList;
  final int voiceIndex;
  final String localVoicePath;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  final int score;
  S2TState({
    @required this.voiceList,
    @required this.voiceIndex,
    @required this.localVoicePath,
    this.errorMessage,
    @required this.isLoading,
    this.isDone= false,
    this.score = 0
  });

  S2TState copyWith({
    List voiceList,
    int voiceIndex,
    String localVoicePath,
    String errorMessage,
    bool isLoading,
    isDone,
    score
  }) {
    return S2TState(
      voiceList: voiceList ?? this.voiceList,
      voiceIndex: voiceIndex ?? this.voiceIndex,
      localVoicePath: localVoicePath ?? this.localVoicePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone : isDone ?? this.isDone,
      score: score ?? this.score
    );
  }

  factory S2TState.initial() {
    return S2TState(
      voiceList: [],
      voiceIndex: -1,
      localVoicePath:'',
      isLoading: true,
      errorMessage: null,
      isDone: false,
      score: 0
    );
  }

  S2TState ready(voiceList,voiceIndex,localVoicePath,score){
    return copyWith(
      voiceList: voiceList,
      voiceIndex: voiceIndex,
      localVoicePath: localVoicePath,
      errorMessage: null,
      isLoading:false,
      score : score
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
      score: score,
    );
  }
}