import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ui.dart';

class Api {
  Map<String, String> header = {
    "Content-Type": "application/json",
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
  };
  FlutterSecureStorage _storage = FlutterSecureStorage();
  String? token;

  Future<List<dynamic>> getall(String url) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}${url}");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json; //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> login(String user, String passwor) async {
    Map<String, String> data = {'username': user, 'password': passwor};
    Map<String, String> header1 = {
      "Content-Type": "application/x-www-form-urlencoded", //
      // "Authorization": "Bearer $token",
    };

    // final uri = Uri.parse();
    final uri = Uri.parse("${Ui.url}login");
    var response = await http.post(uri,
        body: data, headers: header1, encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> l = jsonDecode(utf8.decode(response.bodyBytes));
      await _storage.write(key: 'token', value: l['access_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> save(String url, Object object) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}${url}");
    final response =
        await http.post(uri, headers: header, body: jsonEncode(object));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(
          response.bodyBytes)); //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<dynamic> saveId(
      String url, Object object, String name_id, String id) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Map<String, dynamic> param = {name_id: id};
    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: param);

    final response =
        await http.post(uri, headers: header, body: jsonEncode(object));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(
          response.bodyBytes)); //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception('Error - ${response.statusCode}');
    }
  }

  Future<dynamic> remove(String url, String id) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Map<String, dynamic> param = {"id": id};

    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: param);
    final response =
    await http.put(uri, headers: header);

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(
          response.bodyBytes)); //json.map((e) => Catalog.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }
}
