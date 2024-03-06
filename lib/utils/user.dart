import 'package:app_restaurant/utils/common.dart';
import 'package:http/http.dart' as http;

Future<void> getUserData() async {
  final token = await getToken();
  if (token != null) {
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('https://shop.layoutwebdemo.com/api/staff/login'),
      headers: headers,
    );

    // Process response containing user data
  }
}
