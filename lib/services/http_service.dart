import 'dart:convert';

import 'package:http/http.dart';
import 'package:note_app_api/models/notes_model.dart';


class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "620a2b8192946600171c5837.mockapi.io";
  static String SERVER_PRODUCTION = "620a2b8192946600171c5837.mockapi.io";

  static Map<String, String> getHeaders() {
    Map<String,String> headers = {'Content-Type':'application/json; charset=UTF-8'};
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    var uri = Uri.http(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    if(response.statusCode == 429) return "Too many request";
    return null;
  }

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    var uri = Uri.http(getServer(), api); // http or https
    var response = await post(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    if(response.statusCode == 429) return "Too many request";
    return null;
  }

  static Future<String?> PUT(String api, Map<String, dynamic> params) async {
    var uri = Uri.http(getServer(), api); // http or https
    var response = await put(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200) return response.body;
    if(response.statusCode == 429) return "Too many request";
    return null;
  }

  static Future<String?> PATCH(String api, Map<String, dynamic> params) async {
    var uri = Uri.http(getServer(), api); // http or https
    var response = await patch(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200) return response.body;
    if(response.statusCode == 429) return "Too many request";
    return null;
  }

  static Future<String?> DEL(String api, Map<String, dynamic> params) async {
    var uri = Uri.http(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    if(response.statusCode == 429) return "Too many request";
    return null;
  }

  /* Http Apis */
  static String API_LIST = "/notes";
  static String API_ONE_ELEMENT = "/notes/"; //{id}
  static String API_CREATE = "/notes";
  static String API_UPDATE = "/notes/"; //{id}
  static String API_DELETE = "/notes/"; //{id}

  /* Http Params */
  static Map<String, dynamic> paramsEmpty() {
    Map<String, dynamic> params = {};
    return params;
  }

  static Map<String, dynamic> paramsCreate(Note note) {
    Map<String, dynamic> params = {};
    params.addAll({
      'content': note.content!,
      'createdAt':note.createdAt.toString().substring(0,16),
      'isSelected':note.isSelected
    });
    return params;
  }

  static Map<String, dynamic> paramsUpdate(Note note) {
    Map<String, dynamic> params = {};
    params.addAll({
      'id': note.id,
      'content': note.content!,
      'createdAt':note.createdAt.toString().substring(0,16),
      'isSelected':note.isSelected
    });
    return params;
  }
}