import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/speech2text/s2t_event.dart';
import 'package:hackathon/src/bloc/speech2text/s2t_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class S2TBloc extends Bloc<S2TEvent,S2TState>{
  final _api = locator<ActionAPI>();
  final _prefs = locator<Preference>();
  final random = locator<Random>();

  S2TBloc():super(S2TState.initial());

  @override
  Stream<S2TState> mapEventToState(S2TEvent event) async* {
    // TODO: implement mapEventToState
    if(event is InitialS2TEvent){
      yield*  _mapInitialS2TEventToState(event);
    } else if(event is SkipEvent){
      yield* _mapSkipEventToState(event);
    } else if(event is SubmitEvent){
      yield*  _mapSubmitEventToState(event);
    }
  }

  Stream<S2TState> _mapInitialS2TEventToState(InitialS2TEvent event) async* {
    yield state.loading();
    print(_prefs.getGameList());
    try {
      List voiceList = state.voiceList;
      print(voiceList);
      // get 1 voice url

      final response = await _api.getVoices(event.context,1);
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
        voiceList.addAll(response['voice_path'] as List);
      }
      //check if error message empty
      if(state.errorMessage==null) {
        print("http://5.189.150.137:5100/download_audio/${voiceList[0]}");
        print("downloading");
        final bytes = await readBytes("http://5.189.150.137:5100/download_audio/${voiceList[0]}").timeout(const Duration(seconds: 15));
        print("writing to file");
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/audio.wav');
        await file.writeAsBytes(bytes);
        if (await file.exists()) {
          print("file ready");
          yield state.ready(voiceList, 0,file.path,0);
        }
      }

    } on TimeoutException  catch (err){
      yield state.error("Request timeout");
    } catch (err){
      yield state.error(err.toString());
    }
  }

  Stream<S2TState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
    //we are gonna add new in the list if user skip
    try{
      //get new random number for added problem
      _prefs.addGameList(random.nextInt(3));
      //pop the list
      _prefs.popGameList();
      //yield done
      yield state.next();
    } catch(err){
      yield state.error(err.toString());
    }
  }

  Stream<S2TState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.annotation);
    yield state.loading();
    try{
      //submit the annotation
      print("SUBMITTING THE ANNOTATION");
      print(state.voiceList);
      final response = await _api.annotateVoice(event.context,state.voiceList[0],event.annotation);
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
        if(_prefs.getGameScore() == 9){
          print("DONE");
          _prefs.setGameScore(0);
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