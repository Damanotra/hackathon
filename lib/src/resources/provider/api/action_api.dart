import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackathon/locator.dart';
import 'package:hackathon/src/resources/provider/api/base_api.dart';
import 'package:hackathon/src/resources/provider/shared_preference.dart';
import 'package:http/http.dart';

class ActionAPI  extends BaseAPI {
  final _prefs = locator<Preference>();

  Future<dynamic> getVoices(BuildContext context) async {
    final response = await doPost(
        'get_voice_skip_n',
        {
          "session_id":_prefs.getSessionId(),
          "skip":0,
          "limit":3
        },
        context);
    print(response.toString());
    final result = response;
    print(result.length);
    return Future.value(result);
  }

  Future<dynamic> annotateVoice(BuildContext context,String voicePath, String annotation) async {
    final response = await doPost(
        'annotate_voice',
        {
          "session_id":_prefs.getSessionId(),
          "voice_path":voicePath,
          "text":annotation
        },
        context);
    print(response.toString());
    return response;
  }

  Future<Map> signIn(BuildContext context,String email,String password) async {
    final response = await doPost(
        "signin",
        {
          "email":email,
          "password":password
        },
        context);
    print(response.toString());
    await _prefs.setSessionId(response['session_id']);
    await _prefs.setEmail(email);
    await _prefs.setPassword(password);
    return (response as Map);
  }

  Future<Map> signUp(BuildContext context,String email,String password) async {
    final response = await doPost(
        "signup",
        {
          "email":email,
          "password":password
        },
        context);
    await _prefs.setSessionId(response['session_id']);
    await _prefs.setEmail(email);
    await _prefs.setPassword(password);
    print(response.toString());
    return response;
  }


  Future<Map> checkSession(BuildContext context) async {
    final response = await doPost(
        'user',
        {
          "session_id":_prefs.getSessionId()
        },
        context);
    final responseMap = response as Map;
    return responseMap;
  }

  Future<Map> getVoiceAndText(BuildContext context) async{
    final response = await doPost(
        "get_voice_to_text_skip_n",
        {
          "session_id":_prefs.getSessionId(),
          "skip":0,
          "limit":3
        },
        context);
    print(response.toString());
    return response;
  }

  Future<dynamic> validate(BuildContext context,bool validation, String v2tId) async{
    final response = await doPost(
        "validate_voice_to_text",
        {
          "session_id":_prefs.getSessionId(),
          "v2t_id":v2tId,
          "is_correct":validation
        },
        context);
    return response;
  }

  Future<dynamic> annotateText(BuildContext context, String voicePath, String text) async {
    final file = await MultipartFile.fromPath('audio', voicePath);
    final encodedURL = Uri.encodeFull('$baseURL/annotate_text');
    print(encodedURL);
    final request = MultipartRequest('POST',Uri.parse(encodedURL));
    request.fields['text'] = text;
    request.fields['session_id'] = _prefs.getSessionId();
    request.files.add(file);
    final response = await doMultipart(
        request,
        context);
    print(response.toString());
    return response;
  }

  Future<dynamic> getTexts(BuildContext context) async {
    final response = await doPost(
        'get_text_skip_n',
        {
          "session_id":_prefs.getSessionId(),
          "skip":0,
          "limit":3
        },
        context);
    print(response.toString());
    return response;
  }

}