import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/validate/validate_event.dart';
import 'package:hackathon/src/bloc/validate/validate_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ValidateBloc extends Bloc<ValidateEvent,ValidateState>{
  final _api = locator<ActionAPI>();
  final _prefs = locator<Preference>();
  final random = locator<Random>();

  ValidateBloc():super(ValidateState.initial());

  @override
  Stream<ValidateState> mapEventToState(ValidateEvent event) async* {
    // TODO: implement mapEventToState
    if(event is InitialValidateEvent){
      yield*  _mapInitialValidateEventToState(event);
    } else if(event is SkipEvent){
      yield* _mapSkipEventToState(event);
    } else if(event is SubmitEvent){
      yield*  _mapSubmitEventToState(event);
    }
  }



  Stream<ValidateState> _mapInitialValidateEventToState(InitialValidateEvent event) async* {
    yield state.loading();
    try {
      List voiceList = state.voiceList;
      print(voiceList);
      // get list of 1 voice url
      final response = await _api.getVoiceAndText(event.context,1);
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
        voiceList.addAll(response['data'] as List);
      }
      //check if loop ended because of error
      if(state.errorMessage==null) {
        final voicePath = voiceList[0]['voice_path'];
        print("http://5.189.150.137:5100/download_audio/${voicePath}");
        final bytes = await readBytes("http://5.189.150.137:5100/download_audio/${voicePath}");
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/audio.wav');
        print("bytes downloaded");
        await file.writeAsBytes(bytes);
        if (await file.exists()) {
          yield state.ready(voiceList, 0,file.path, 0);
        }
      }
    }  catch (err){
      yield state.error(err.toString());
    }
  }

  Stream<ValidateState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
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

  Stream<ValidateState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.validation);
    yield state.loading();
    try{
      //submit the validation
      print("SUBMIT VALIDATION");
      final v2tId = state.voiceList[0]["v2t_id"];
      final response = await _api.validate(event.context, event.validation, v2tId);
      //check session
      if(response['note']!=null){
        if(response['note']=="invalid session"){
          print("session expired");
          yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
        }
        else {
          yield state.error("terjadi kesalahan ${response['note']}");
        }
      } else{
        //if session valid
        final submitSuccess = response['success'];
        print(submitSuccess);
        //check if validation true
        if(response['result'] == true){
          print("VALIDATION TRUE");
          if(_prefs.getGameScore()== 9){
            print("DONE");
            _prefs.setGameScore(0);
            _prefs.setGameList([]);
            yield state.done();
          } else {
            _prefs.plusGameScore();
          }
        } else {
          print("VALIDATION FALSE");
          //if validation false, minus point
          _prefs.minusGameScore();
          //get more instances because of false validation
          print("GETTING 2 MORE PROBLEM");
          _prefs.addGameList(random.nextInt(3));
          _prefs.addGameList(random.nextInt(3));
        }
        //if the game not yet done, forward to next problem
        print("FORWARDED TO NEXT");
        if(state.isDone==false){
          //pop the list
          _prefs.popGameList();
          //yield next
          yield state.next();
        }
      }

    } catch(err){
      yield state.error(err.toString());
    }
  }
}