import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/speech2text/s2t_event.dart';
import 'package:hackathon/src/bloc/speech2text/s2t_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class S2TBloc extends Bloc<S2TEvent,S2TState>{
  final _api = locator<ActionAPI>();

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
    try {
      final  voiceList = await _api.getVoices(event.context);
      print("http://5.189.150.137:5000/download_audio/${voiceList[0]}");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${voiceList[0]}");
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

  Stream<S2TState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
    try{
      final voiceIndex = state.voiceIndex+1;
      print("http://5.189.150.137:5000/download_audio/${state.voiceList[voiceIndex]}");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${state.voiceList[0]}");
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

  Stream<S2TState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.annotation);
    yield state.loading();
    try{
      final  submitSuccess = await _api.annotateVoice(event.context,state.voiceList[state.voiceIndex],event.annotation);
      print(submitSuccess);
      //next index in the list
      final voiceIndex = state.voiceIndex+1;
      print("http://5.189.150.137:5000/download_audio/${state.voiceList[voiceIndex]}");
      final bytes = await readBytes("http://5.189.150.137:5000/download_audio/${state.voiceList[0]}");
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