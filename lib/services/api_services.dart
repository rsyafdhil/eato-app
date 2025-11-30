import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your Laravel backend URL
  // For Android Emulator: use 10.0.2.2
  // For iOS Simulator: use localhost
  // For Real Device: use your computer's IP address (e.g., 192.168.1.100)
  static const String baseUrl = "http://localhost:8000/api";
  
  // Store token after login
  static String? _token;

  // Set token
  static void setToken(String token) {
    _token = token;
  }

  // Get token
  static String? getToken() {
    return _token;
  }

  // Clear token (for logout)
  static void clearToken() {
    _token = null;
  }

  // Get headers with authorization
  static Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    
    if (_token != null) {
      headers["Authorization"] = "Bearer $_token";
    }
    
    return headers;
  }

  // ==================== AUTH ENDPOINTS ====================
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        // Save token
        if (data['data'] != null && data['data']['token'] != null) {
          setToken(data['data']['token']);
        }
      }
      
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String nomorTelefon,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "nomor_telefon": nomorTelefon,
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        // Save token
        if (data['data'] != null && data['data']['token'] != null) {
          setToken(data['data']['token']);
        }
      }
      
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: _getHeaders(),
      );

      clearToken();
      return json.decode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Logout error: $e',
      };
    }
  }

  // ==================== TENANT ENDPOINTS ====================
  
  static Future<List<dynamic>> getTenants() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tenants"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error fetching tenants: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getTenantById(int id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tenants/$id"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching tenant: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getItemsByTenant(int tenantId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tenants/$tenantId/items"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }

  // ==================== ITEM ENDPOINTS ====================
  
  static Future<List<dynamic>> getItems() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getItemById(int id) async {
    try {
      print('>>> getItemById($id): Making request to $baseUrl/items/$id');
      print('>>> getItemById($id): Headers = ${_getHeaders()}');
      
      final response = await http.get(
        Uri.parse("$baseUrl/items/$id"),
        headers: _getHeaders(),
      );

      print('>>> getItemById($id): Status Code = ${response.statusCode}');
      print('>>> getItemById($id): Response Body = ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('>>> getItemById($id): Decoded data = $data');
        print('>>> getItemById($id): Returning data[\'data\'] = ${data['data']}');
        return data['data'];
      } else {
        print('>>> getItemById($id): ERROR - Status ${response.statusCode}');
        print('>>> getItemById($id): ERROR Body = ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('>>> getItemById($id): EXCEPTION = $e');
      print('>>> getItemById($id): Stack trace = $stackTrace');
      return null;
    }
  }

  // ==================== ORDER ENDPOINTS ====================
  
  static Future<Map<String, dynamic>> createOrder({
    required int userId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/orders"),
        headers: _getHeaders(),
        body: json.encode({
          "user_id": userId,
          "items": items,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Order error: $e',
      };
    }
  }

  // ==================== USER ENDPOINTS ====================
  
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}