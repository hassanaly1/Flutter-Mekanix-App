import 'dart:convert';

import 'package:flutter_mekanix_app/services/api_endpoints.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  static String apiUrl =
      '${ApiEndPoints.baseUrl}${ApiEndPoints.getAnalyticsUrl}';

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
