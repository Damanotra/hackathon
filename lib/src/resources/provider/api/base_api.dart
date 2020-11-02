import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:hackathon/locator.dart';

var header = {
  'content-type': 'application/json',
  'accept': 'application/json',
};

class BaseAPI{
  String baseURL;

  BaseAPI(){
    baseURL = 'http://5.189.150.137:5000/';
  }

  Future<dynamic> doPost(String url,dynamic body,BuildContext context) async {
    final encodedURL = Uri.encodeFull('$baseURL/$url');
    print('doPost : $encodedURL $body');
    final header = getHeader();

    final response = await post(encodedURL, headers: header, body: json.encode(body));
    print('Got Response ? ${response.statusCode}');
    if (response.statusCode == StatusCode.success) {
      final result = json.decode(response.body);
      print('SUCCESS : $result');
      return result;
    } else {
      await handleError(response);
//      return doPost(url, body, context);
    }
  }

  Future<Map<String, dynamic>> doGet(String url, BuildContext context) async {
    final encodedURL = Uri.encodeFull('$baseURL/$url');
    print('doGet : $encodedURL');
    final header = getHeader();
    print('HEADER : $header');

    final response = await get(encodedURL, headers: header);
    print('Got Response ? ${response.statusCode}');
    if (response.statusCode == StatusCode.success) {
      final result = Map<String, dynamic>.from(json.decode(response.body));
      print('SUCCESS : $result');
      return result;
    } else {
      await handleError(response);
//      return doGet(url, context);
    }
  }



  void handleError(dynamic response) async {
    print('FAILED : ${response.statusCode} : ${response.body}');
    final error = json.decode(response.body);
  }


  Map<String, String> getHeader() {
    var header = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    //final token = prefs.getToken();
//    if (token != null && token != '') {
//      header['Authorization'] = token;
//    }

    return header;
  }


}

class StatusCode {
  static const int success = 200;
  static const int tokenExpired = 404;
  static const int unauthorized = 404;
}

class APIException implements Exception {
  final String message;

  const APIException(this.message);
  String toString() => message;
}