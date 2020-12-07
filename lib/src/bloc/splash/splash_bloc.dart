import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/splash/splash_event.dart';
import 'package:hackathon/src/bloc/splash/splash_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial());
  final _api = locator<ActionAPI>();

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
      final response = await _api.checkSession(event.context);
      if (response['note'] == null) {
        yield state.success(response['data']['contribution'],response['data']['point'],response['data']['minus_point']);
      } else {
        yield state.ready(null);
      }
    } catch (err) {
      yield state.ready(err.toString());
    }
  }
}
