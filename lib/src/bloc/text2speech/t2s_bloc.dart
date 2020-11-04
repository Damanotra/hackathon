import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/bloc/text2speech/t2s_event.dart';
import 'package:hackathon/src/bloc/text2speech/t2s_state.dart';
import 'package:hackathon/src/resources/provider/api/action_api.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class T2SBloc extends Bloc<T2SEvent,T2SState>{
  final _api = locator<ActionAPI>();

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
//      final  voiceList = await _api.getTexts(event.context);
      yield state.ready(0);
    }  catch (err){
      yield state.error(err.toString());
    }
  }

  Stream<T2SState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
    try{
      if(state.textIndex == state.textList.length-1){
        yield state.done();
      } else{
        final textIndex = state.textIndex+1;
        yield state.ready(textIndex);
      }

    } catch(err){
      yield state.error(err.toString());
    }
  }

  Stream<T2SState> _mapSubmitEventToState(SubmitEvent event) async* {
    print(event.voicePath);
    yield state.loading();
    try{
      final submitSuccess = await _api.annotateText(event.context,event.voicePath,event.text);
      print(submitSuccess);
      //check if done
      if(state.textIndex == state.textList.length-1){
        yield state.done();
      } else{
        //go to next index
        final textIndex = state.textIndex+1;
        yield state.ready(textIndex);
      }
    } catch(err){
      yield state.error(err.toString());
    }
  }
}