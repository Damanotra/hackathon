

class SignupState{
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  SignupState({this.isLoading,this.isSuccess,this.errorMessage});

  SignupState copyWith({
    bool isLoading,
    bool isSuccess,
    String errorMessage,
  }) {
    return SignupState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SignupState.initial() {
    return SignupState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
    );
  }

  SignupState ready(errorMessage){
    return copyWith(
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  SignupState loading(){
    return copyWith(
      isLoading: true
    );
  }

  SignupState success(){
    return copyWith(
      isLoading: false,
      isSuccess: true,
      errorMessage: null
    );
  }
}

