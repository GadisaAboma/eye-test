import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;

class PatientsProvider extends ChangeNotifier {
  Future registerPatient(
      String name, String id, String age, String gender, File image) async {
    var url = Uri.parse('$baseUrl/patients/register-patient');
    try {
      var request = http.MultipartRequest('post', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.fields['name'] = name;
      request.fields['id'] = id;
      request.fields['gender'] = gender;
      request.fields['age'] = age.toString();
      request.fields['creator'] = "dfdfdf";
      var img = await http.MultipartFile.fromPath("picture", image.path);
      request.files.add(img);
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      if (response.statusCode == 400) {
        throw json.decode(response.body)['message'];
      }

      notifyListeners();
      return json.decode(response.body)['message'];
    } catch (err) {
      rethrow;
    }
  }

  Future findPatient(String name, String id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    

    final body = json.encode({"name": name, "id": id});

    try {
      final url = Uri.parse('$baseUrl/patients/find-patient');
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 400) {
        throw json.decode(response.body)['message'];
      } else {
        final data = json.decode(response.body);
        notifyListeners();
        return data;
      }
    } catch (err) {
      rethrow;
    }
  }
}
