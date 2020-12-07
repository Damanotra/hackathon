import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/text2speech/t2s_event.dart';
import 'package:hackathon/src/bloc/text2speech/t2s_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';


class T2SBloc extends Bloc<T2SEvent,T2SState>{
  final _api = locator<ActionAPI>();
  final _prefs = locator<Preference>();
  final random = locator<Random>();

  T2SBloc():super(T2SState.initial());

  @override
  Stream<T2SState> mapEventToState(T2SEvent event) async* {
    // TODO: implement mapEventToState
    if(event is InitialT2SEvent){
      yield*  _mapInitialT2SEventToState(event);
    } else if(event is SkipEvent){
      yield* _mapSkipEventToState(event);
    } else if(event is SubmitEvent){
      yield*  _mapSubmitEventToState(event);
    }
  }

  Stream<T2SState> _mapInitialT2SEventToState(InitialT2SEvent event) async* {
    yield state.loading();
    try {
      final textList = state.textList;
      print(textList);
      // get list of 1 texts
      final response = await _api.getTexts(event.context,1);
      if(response['note']!=null){
        if(response['note']=="invalid session"){
          print("session expired");
          yield state.copyWith(errorMessage: "Session kadaluarsa, mohon restart app dan login ulang");
          yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
        }
        else {
          yield state.copyWith(errorMessage: "terjadi kesalahan ${response['note']}");
          yield state.error("terjadi kesalahan ${response['note']}");
        }
      } else {
        textList.addAll(response['text'] as List);
      }
      //check if error message exist
      if(state.errorMessage==null) {
        yield state.ready(textList,0,0);
      }
    }  catch (err){
      yield state.error(err.toString());
    }
  }

  Stream<T2SState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
    try{
      //get new random number for added problem
      _prefs.addGameList(random.nextInt(3));
      //pop the list
      _prefs.popGameList();
      //yield next
      yield state.next();
    } catch(err){
      yield state.error(err.toString());
    }
  }

  Stream<T2SState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.voicePath);
    yield state.loading();
    try{
      print("SUBMITTING THE ANNOTATION");
      print(state.textList);
      final response = await _api.annotateText(event.context,event.voicePath,event.text);
      //check if fails
      if(response['note']!=null){
        if(response['note']=="invalid session"){
          print("session expired");
          yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
        }
        else {
          yield state.error("terjadi kesalahan ${response['note']}");
        }
      } else {
        //if success
        print("SUBMISSION SUCCESS");
        //check if the score become 10 once submit success
        if(_prefs.getGameScore() == _prefs.getGameMax()-1){
          print("DONE");
          _prefs.setGameScore(0);
          _prefs.setGameList([]);
          yield state.done();
        } else {
          //else, add score
          _prefs.plusGameScore();
          print("FORWARD");
          //if not done, forward to next problem by deleting current game
          _prefs.popGameList();
          yield state.next();
        }
      }
    } catch(err){
      yield state.error(err.toString());
    }
  }
}