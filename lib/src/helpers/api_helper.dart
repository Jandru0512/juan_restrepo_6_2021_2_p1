import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:juan_restrepo_6_2021_2_p1/src/models/new.dart';
import 'package:juan_restrepo_6_2021_2_p1/src/models/response.dart';

import 'constants.dart';

class ApiHelper {
  static Future<Response> getNews(String filter) async {
    var url = Uri.parse('${Constants.apiUrl}/news?category=$filter');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    );
    
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<New> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null && decodedJson["data"] != null) {
      for (var item in decodedJson["data"]) {
        list.add(New.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: list);
  }
}
