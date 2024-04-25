import 'dart:convert';

import 'package:http/http.dart' as http;

class Request {
  static Future<dynamic> get(Uri uri,
      {required Map<String, String> headers}) async {
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw http.ClientException('Timeout while fetching data');
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw http.ClientException(
            'Error while fetching data with status code: ${response.statusCode}');
      } else if (response.statusCode == 429) {
        throw http.ClientException(
            'Error while fetching data with status code: ${response.statusCode}');
      } else {
        throw http.ClientException(
            'Error while fetching data with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
