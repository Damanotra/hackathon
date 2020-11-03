import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/signup/signup_event.dart';
import 'package:hackathon/src/bloc/signup/signup_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.initial());
  final _api = locator<ActionAPI>();
  final _prefs = locator<Preference>();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitialSignupEvent) {
      yield* _mapInitialSignupEventToState(event);
    } else if (event is SubmitEvent) {
      yield* _mapSubmitEventToState(event);
    }
  }

  Stream<SignupState> _mapInitialSignupEventToState(
      InitialSignupEvent event) async* {
    yield state.loading();
    try {
      yield state.ready(null);
    } catch (err) {
      yield state.ready(err.toString());
    }
  }

  Stream<SignupState> _mapSubmitEventToState(SubmitEvent event) async* {
    yield state.loading();
    try {
      final signupResponse =
          await _api.signUp(event.context, event.email, event.password);
      if (signupResponse['note'] == null) {
        yield state.success();
      } else {
        yield state.ready(signupResponse['note'].toString());
      }
    } catch (err) {
      yield state.ready(err.toString());
    }
  }
}
