import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkService {

  Future getData(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error in URL");
    }
  }
}