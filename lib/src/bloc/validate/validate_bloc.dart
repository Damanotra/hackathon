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
      final responseMap = await _api.getVoiceAndText(event.context);
      final voiceList = responseMap['data'];
      final voicePath = voiceList[0]['voice_path'];
      print("http://5.189.150.137:5000/download_audio/${voicePath}");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${voicePath}");
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/audio.wav');
      print("bytes downloaded");
      await file.writeAsBytes(bytes);
      if (await file.exists()) {
        yield state.ready(voiceList, 0,file.path);
      }
    }  catch (err){
      yield state.error(err.toString());
    }
  }

  Stream<ValidateState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
    try{
      if(state.voiceIndex == state.voiceList.length-1){
        yield state.done();
      }
      final voiceIndex = state.voiceIndex+1;
      final voicePath = state.voiceList[0]['voice_path'];
      print("http://5.189.150.137:5000/download_audio/${voicePath}");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${voicePath}");
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/audio.wav');
      print("bytes downloaded");
      await file.writeAsBytes(bytes);
      if (await file.exists()) {
        yield state.ready(state.voiceList,voiceIndex,file.path);
      }
    } catch(err){
      yield state.error(err.toString());
    }
  }

  Stream<ValidateState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.validation);
    yield state.loading();
    try{
      final v2tId = state.voiceList[state.voiceIndex]["v2t_id"];
      final  submitSuccess = await _api.validate(event.context, event.validation, v2tId);
      print(submitSuccess);
      //next index in the list
      final voiceIndex = state.voiceIndex+1;
      String voicePath;
      if(state.voiceList[voiceIndex]['voice_path'].substring(0,6)=="voice/"){
        voicePath = state.voiceList[voiceIndex]['voice_path'].substring(6);
      } else {
        voicePath = state.voiceList[voiceIndex]['voice_path'];
      }
      print("http://5.189.150.137:5000/download_audio/${voicePath}");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${voicePath}");
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/audio.wav');
      print("bytes downloaded");
      await file.writeAsBytes(bytes);
      if (await file.exists()) {
        yield state.ready(state.voiceList,voiceIndex,file.path);
      }
    } catch(err){
      yield state.error(err.toString());
    }
  }
}