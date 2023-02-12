import 'dart:convert';
import 'package:chatapp/models/quick_rooms.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

const String baseUrl = 'https://iraqchatapp.pythonanywhere.com/api/';

class BaseClient {
  var client = http.Client();
  //GET
  Future<List<QRoom>?> get_rooms(String api) async {
     debugPrint('ima in  get rooms');
    var url = Uri.parse(baseUrl + api);
   debugPrint('url is $url');
    var response = await client.get(url);
     debugPrint('response is 200');
    if (response.statusCode == 200) {
      var json = response.body;
        
      return roomfromjson(json);
    } else {
      debugPrint('error in get rooms');
      return null;
    }
  }

  //post room
  Future<dynamic> post_room(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer sfie328370428387=',
      // 'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.post(url, body: _payload, headers: _headers);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  //POST
  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var _payload = json.encode(object);
    var _headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'Content-Type': 'application/json',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.post(url, body: _payload, headers: _headers);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  ///PUT Request
  Future<dynamic> put(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var _payload = json.encode(object);
    var _headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'Content-Type': 'application/json',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.put(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  //delete
  Future<dynamic> delete(String api) async {
    var url = Uri.parse(baseUrl + api);
    var _headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.delete(url, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }
}
