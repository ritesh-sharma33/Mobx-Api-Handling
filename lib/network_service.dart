import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobx_api_handling/user.dart';

class NetworkService {

  List<User> users = List();

  Future getData(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      users = (data['data'] as List).map((json) {
        return User.fromJSON(json);
      }).toList();
      return users;
    } else {
      print("Error in URL");
    }
  }
}