class ValidateState{
  final List voiceList;
  final int voiceIndex;
  final String localVoicePath;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  final int score;
  ValidateState({this.voiceList, this.voiceIndex,this.localVoicePath, this.errorMessage, this.isLoading, this.isDone, this.score});

  ValidateState copyWith({
    List voiceList,
    int voiceIndex,
    String localVoicePath,
    String errorMessage,
    bool isLoading,
    bool isDone,
    int score
  }) {
    return ValidateState(
      voiceList: voiceList ?? this.voiceList,
      voiceIndex: voiceIndex ?? this.voiceIndex,
      localVoicePath: localVoicePath ?? this.localVoicePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone,
      score: score ?? this.score
    );
  }

  factory ValidateState.initial() {
    return ValidateState(
      voiceList: [],
      voiceIndex: -1,
      localVoicePath:'',
      isLoading: true,
      errorMessage: null,
      isDone: false,
      score: 0
    );
  }

  ValidateState ready(voiceList,voiceIndex,localVoicePath,score){
    return copyWith(
      voiceList: voiceList,
      voiceIndex: voiceIndex,
      localVoicePath: localVoicePath,
      errorMessage: null,
      isLoading:false,
      score: score
    );
  }

  ValidateState loading(){
    return copyWith(
      isLoading: true,
      errorMessage: null,
    );
  }

  ValidateState error(errorMessage){
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage
    );
  }

  ValidateState done(){
    return copyWith(
      isLoading: false,
      errorMessage: null,
      isDone: true
    );
  }
}