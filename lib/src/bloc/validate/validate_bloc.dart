import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/validate/validate_event.dart';
import 'package:hackathon/src/bloc/validate/validate_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ValidateBloc extends Bloc<ValidateEvent,ValidateState>{
  final _api = locator<ActionAPI>();

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
      // get list of 10 voice url
      while(voiceList.length<10 && state.errorMessage==null){
        final response = await _api.getVoiceAndText(event.context,3);
        if(response['note']!=null){
          if(response['note']=="invalid session"){
            print("session expired");
            yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
          }
          else {
            yield state.error("terjadi kesalahan ${response['note']}");
          }
        } else {
          voiceList.addAll(response['data'] as List);
        }
      }
      //check if loop ended because of error
      if(state.errorMessage==null) {
        final voicePath = voiceList[0]['voice_path'];
        print("http://5.189.150.137:5000/download_audio/${voicePath}");
        final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${voicePath}");
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
    List voiceList = state.voiceList;
    try{
      //get new instance of problem
      final response = await _api.getVoiceAndText(event.context,1);
      if(response['note']!=null){
        if(response['note']=="invalid session"){
          print("session expired");
          yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
        }
        else {
          yield state.error("terjadi kesalahan ${response['note']}");
        }
      } else {
        //add the requested instance
        voiceList.addAll(response['data'] as List);
      }
      if(state.score == 10){
        //check if the score become 10 once skipped *impossible
        yield state.done();
      }
      //after preparation, forward to next problem
      final voiceIndex = state.voiceIndex+1;
      final voicePath = state.voiceList[voiceIndex]['voice_path'];
      print("http://5.189.150.137:5000/download_audio/$voicePath");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/$voicePath");
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/audio.wav');
      print("bytes downloaded");
      await file.writeAsBytes(bytes);
      if (await file.exists()) {
        yield state.ready(state.voiceList,voiceIndex,file.path,state.score);
      }
    } catch(err){
      yield state.error(err.toString());
    }
  }

  Stream<ValidateState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.validation);
    yield state.loading();
    int score;
    try{
      //submit the validation
      print("SUBMIT VALIDATION");
      final v2tId = state.voiceList[state.voiceIndex]["v2t_id"];
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
          if(state.score== 9){
            yield state.done();
          } else {
            score = state.score +1;
          }
        } else {
          print("VALIDATION FALSE");
          //if validation false, minus point
          score = state.score - 1;
          if(score<0) score = 0;
          //get more instances because of false validation
          print("GETTING MORE PROBLEM");
          List voiceList = state.voiceList;
          final response = await _api.getVoiceAndText(event.context,1);
          if(response['note']!=null){
            if(response['note']=="invalid session"){
              print("session expired");
              yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
            }
            else {
              yield state.error("terjadi kesalahan ${response['note']}");
            }
          } else {
            voiceList.addAll(response['data'] as List);
          }
        }
        //if the game not yet done, forward to next problem
        print("FORWARDED TO NEXT");
        if(state.isDone==false){
          final voiceIndex = state.voiceIndex+1;
          print("http://5.189.150.137:5000/download_audio/${state.voiceList[voiceIndex]['voice_path']}");
          final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${state.voiceList[voiceIndex]['voice_path']}");
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/audio.wav');
          print("bytes downloaded");
          await file.writeAsBytes(bytes);
          if (await file.exists()) {
            yield state.ready(state.voiceList,voiceIndex,file.path,score);
          }
        }

      }

    } catch(err){
      yield state.error(err.toString());
    }
  }
}