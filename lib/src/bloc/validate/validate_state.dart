class ValidateState{
  final List voiceList;
  final String localVoicePath;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  final bool isNext;
  ValidateState({
    this.voiceList,
    this.localVoicePath,
    this.errorMessage,
    this.isLoading,
    this.isDone = false,
    this.isNext = false
  });

  ValidateState copyWith({
    List voiceList,
    String localVoicePath,
    String errorMessage,
    bool isLoading,
    bool isDone,
    bool isNext
  }) {
    return ValidateState(
      voiceList: voiceList ?? this.voiceList,
      localVoicePath: localVoicePath ?? this.localVoicePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone,
      isNext: isNext ?? this.isNext
    );
  }

  factory ValidateState.initial() {
    return ValidateState(
      voiceList: [],
      localVoicePath:'',
      isLoading: true,
      errorMessage: null,
      isDone: false,
      isNext: false,
    );
  }

  ValidateState ready(voiceList,voiceIndex,localVoicePath,score){
    return copyWith(
      voiceList: voiceList,
      localVoicePath: localVoicePath,
      errorMessage: null,
      isLoading:false,
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

  ValidateState next(){
    return copyWith(
        isLoading: true,
        errorMessage: null,
        isNext: true
    );
  }
}