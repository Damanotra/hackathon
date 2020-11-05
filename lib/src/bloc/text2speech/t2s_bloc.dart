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
      List textList = state.textList;
      print(textList);
      // get list of 10 texts
      while(textList.length<10 && state.errorMessage==null){
        final response = await _api.getTexts(event.context,3);
        if(response['note']!=null){
          if(response['note']=="invalid session"){
            print("session expired");
            yield state.error("Session kadaluarsa, mohon restart app dan login ulang");
          }
          else {
            yield state.error("terjadi kesalahan ${response['note']}");
          }
        } else {
          textList.addAll(response['text'] as List);
        }
      }
      if(state.errorMessage==null) {
        yield state.ready(textList,0,0);
      }
    }  catch (err){
      yield state.error(err.toString());
    }
  }

  Stream<T2SState> _mapSkipEventToState(SkipEvent event) async* {
    yield state.loading();
    List textList = state.textList;
    try{
      //get new instance of problem
      final response = await _api.getTexts(event.context,1);
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
        textList.addAll(response['text'] as List);
      }
      if(state.isDone==false){
        //if not done, forward to next problem index
        yield state.ready(state.textList, state.textIndex+1,state.score);
      }
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
      print(state.textIndex);
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
        if (state.score == 9) {
          print("DONE");
          //check if the score become 10 once submit success
          yield state.done();
        } else {
          print("FORWARD");
          //if not done, forward to next problem
          final textIndex = state.textIndex + 1;
          yield state.ready(state.textList, state.textIndex+1,state.score+1);
        }
      }
    } catch(err){
      yield state.error(err.toString());
    }
  }
}