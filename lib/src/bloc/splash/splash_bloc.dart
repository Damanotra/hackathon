import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/splash/splash_event.dart';
import 'package:hackathon/src/bloc/splash/splash_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial());
  final _api = locator<ActionAPI>();
  final _prefs = locator<Preference>();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitialSplashEvent) {
      yield* _mapInitialSplashEventToState(event);
    }
  }

  Stream<SplashState> _mapInitialSplashEventToState(InitialSplashEvent event) async* {
    yield state.loading();
    try {
      final checkSession = await _api.checkSession(event.context);
      if (checkSession['note'] == null) {
        yield state.success();
      } else {
        yield state.ready(null);
      }
    } catch (err) {
      yield state.ready(err.toString());
    }
  }
}
