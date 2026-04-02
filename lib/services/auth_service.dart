import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = "http://127.0.0.1:3000";

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print("[AUTH] Login attempt for $email to $_baseUrl");
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("[AUTH] Login status: ${response.statusCode}");
      print("[AUTH] Login body: ${response.body}");

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "message": "Login successful", ...body};
      } else {
        return {"success": false, "message": body['message'] ?? "Invalid credentials"};
      }
    } catch (e) {
      print("[AUTH] Login Error: $e");
      return {"success": false, "message": "Could not connect to the backend server."};
    }
  }

  static Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      print("[AUTH] Signup attempt for $email to $_baseUrl");
      final response = await http.post(
        Uri.parse("$_baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("[AUTH] Signup status: ${response.statusCode}");
      print("[AUTH] Signup body: ${response.body}");

      if (response.statusCode == 201) {
        return {"success": true, "message": "User created successfully", "data": jsonDecode(response.body)};
      } else {
        final body = jsonDecode(response.body);
        return {"success": false, "message": body['message'] ?? "Failed to create account"};
      }
    } catch (e) {
      print("[AUTH] Signup Error: $e");
      return {"success": false, "message": "Could not connect to the backend server."};
    }
  }
}
