import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/lobby/lobby_event.dart';
import 'package:hackathon/src/bloc/lobby/lobby_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc() : super(LobbyState.initial());
  final _api = locator<ActionAPI>();

  @override
  Stream<LobbyState> mapEventToState(LobbyEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitialLobbyEvent) {
      yield* _mapInitialLobbyEventToState(event);
    } else if (event is InitialNoLoadingEvent) {
      yield* _mapInitialNoLoadingEventToState(event);
    }
  }

  Stream<LobbyState> _mapInitialLobbyEventToState(InitialLobbyEvent event) async* {
    yield state.loading();
    try {
      final response = await _api.checkSession(event.context);
      if (response['note'] == null) {
        yield state.ready(response['data']['contribution'], response['data']['point'], response['data']['minus_point']);
      } else if(response['note'] == "invalid session"){
        yield state.relog();
      } else {
        yield state.error(response['note']);
      }
    } catch (err) {
      yield state.error(err.toString());
    }
  }

  Stream<LobbyState> _mapInitialNoLoadingEventToState(InitialNoLoadingEvent event) async* {
    try {
      yield state.ready(event.contribution, event.points, event.minusPoints);
    } catch (err) {
      yield state.error(err.toString());
    }
  }
}
