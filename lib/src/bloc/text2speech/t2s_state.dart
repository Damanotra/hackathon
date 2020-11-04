class T2SState{
  final List textList;
  final int textIndex;
  final String errorMessage;
  final bool isLoading;
  final bool isDone;
  T2SState({this.textList, this.textIndex, this.errorMessage, this.isLoading,this.isDone});

  T2SState copyWith({
    List textList,
    int textIndex,
    String errorMessage,
    bool isLoading,
    bool isDone
  }) {
    return T2SState(
      textList: textList ?? this.textList,
      textIndex: textIndex ?? this.textIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isDone: isDone ?? this.isDone
    );
  }

  factory T2SState.initial() {
    return T2SState(
      textList: [],
      textIndex: -1,
      isLoading: true,
      errorMessage: null,
      isDone: false
    );
  }

  T2SState ready(textIndex){
    return copyWith(
      textList: ['Coba Baca Ini','Pengen Makan Nasi'],
      textIndex: textIndex,
      errorMessage: null,
      isLoading:false
    );
  }

  T2SState loading(){
    return copyWith(
      isLoading: true,
      errorMessage: null,
    );
  }

  T2SState error(errorMessage){
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage
    );
  }

  T2SState done(){
    return copyWith(
        isLoading: false,
        errorMessage: null,
        isDone: true
    );
  }
}