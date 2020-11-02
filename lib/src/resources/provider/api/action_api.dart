import 'package:flutter/material.dart';
import 'package:hackathon/src/resources/provider/api/base_api.dart';

class ActionAPI  extends BaseAPI {

  Future<List<dynamic>> getVoices(BuildContext context) async {

    final response = await doPost(
        'get_voice_skip_n',
        {
          "session_id":"5fa015b99cec57a8e8b5e10a",
          "skip":0,
          "limit":3
        },
        context);
    print(response.toString());
    final result = List.from(response['voice_path']);
    print(result.length);
    return Future.value(result);
  }

  Future<bool> annotateVoice(BuildContext context,String voicePath, String annotation) async {
    final response = await doPost(
        'annotate_voice',
        {
          "session_id":"5fa015b99cec57a8e8b5e10a",
          "voice_path":voicePath,
          "text":annotation
        },
        context);
    print(response.toString());
    return response['success'];
  }


}