import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000/api";
  // Android emulator → gunakan 10.0.2.2
  // Device fisik → pakai IP LAN laptop kamu

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> register(
    String nomorTelefon,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      body: {
        "nomor_telefon": nomorTelefon,
        "email": email,
        "password": password,
      },
    );

    return jsonDecode(response.body);
  }
}
