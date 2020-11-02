class S2TState{
  final List voiceList;
  final int voiceIndex;
  final String localVoicePath;
  final String errorMessage;
  final bool isLoading;
  S2TState({this.voiceList, this.voiceIndex,this.localVoicePath, this.errorMessage, this.isLoading});

  S2TState copyWith({
    List voiceList,
    int voiceIndex,
    String localVoicePath,
    String errorMessage,
    bool isLoading
  }) {
    return S2TState(
      voiceList: voiceList ?? this.voiceList,
      voiceIndex: voiceIndex ?? this.voiceIndex,
      localVoicePath: localVoicePath ?? this.localVoicePath,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading
    );
  }

  factory S2TState.initial() {
    return S2TState(
      voiceList: [],
      voiceIndex: -1,
      localVoicePath:'',
      isLoading: true,
      errorMessage: null,
    );
  }

  S2TState ready(voiceList,voiceIndex,localVoicePath){
    return copyWith(
      voiceList: voiceList,
      voiceIndex: voiceIndex,
      localVoicePath: localVoicePath,
      errorMessage: null,
      isLoading:false
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
}