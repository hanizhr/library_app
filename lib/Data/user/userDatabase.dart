import 'dart:convert';
import 'package:library_app/Data/user/user.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('http://localhost:3000/users'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);

    List<User> users = jsonData.map((json) => User.fromJson(json)).toList();

    return users;
  } else {
    throw Exception('Failed to fetch users');
  }
}

Future<void> registerUser(String name, String email, int id) async {
  final url = Uri.parse('http://localhost:3000/register');

  final Map<String, String> requestBody = {
    'name': name,
    'email': email,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      print('User registered successfully!');
    } else {
      print('Failed to register user. Error: ${response.body}');
      throw Exception('Failed to register user.');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to connect to the server.');
  }
}
