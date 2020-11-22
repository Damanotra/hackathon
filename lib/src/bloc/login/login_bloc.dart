import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/login/login_event.dart';
import 'package:hackathon/src/bloc/login/login_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial());
  final _api = locator<ActionAPI>();
  final _prefs = locator<Preference>();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitialLoginEvent) {
      yield* _mapInitialLoginEventToState(event);
    } else if (event is SubmitEvent) {
      yield* _mapSubmitEventToState(event);
    }
  }

  Stream<LoginState> _mapInitialLoginEventToState(InitialLoginEvent event) async* {
    try {
      yield state.ready(null);
    } catch (err) {
      yield state.ready(err.toString());
    }
  }

  Stream<LoginState> _mapSubmitEventToState(SubmitEvent event) async* {
    yield state.loading();
    try {
      final loginResponse =
          await _api.signIn(event.context, event.email, event.password);
      if (loginResponse['note'] == null) {
        yield state.success();
      } else {
        yield state.ready(loginResponse['note'].toString());
      }
    } catch (err) {
      yield state.ready(err.toString());
    }
  }
}
