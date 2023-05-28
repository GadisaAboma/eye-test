import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;

class DoctorsProvider extends ChangeNotifier {
  Future registerDoctor(String name, String email, String password) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body =
        json.encode({"name": name, "email": email, "password": password});
    print(body);

    try {
      final url = Uri.parse('$baseUrl/doctors/register-doctor');
      final response = await http.post(url, body: body, headers: headers);

      final data = json.decode(response.body);

      if (response.statusCode == 400) {
        throw data['message'];
      }
      print(data);
      notifyListeners();
      return data;
    } catch (err) {
      rethrow;
    }
  }

  Future loginDoctor(String email, String password) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = json.encode({"email": email, "password": password});
    print(body);

    try {
      final url = Uri.parse('$baseUrl/doctors/login-doctor');
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 400) {
        throw json.decode(response.body)['message'];
      } else {
        final data = json.decode(response.body);
        print(data);
        notifyListeners();
        return data;
      }
    } catch (err) {
      rethrow;
    }
  }
}
