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

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Connection error: $e'};
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
      return {'success': false, 'message': 'Logout error: $e'};
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
      final response = await http.get(
        Uri.parse("$baseUrl/items/$id"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching item: $e');
      return null;
    }
  }

  // ==================== ORDER ENDPOINTS ====================

  static Future<Map<String, dynamic>> getOrderStatus(int orderId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/orders/$orderId/status"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      return {'status': 'pending'};
    } catch (e) {
      print('Error checking order status: $e');
      return {'status': 'pending'};
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required int userId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/orders"),
        headers: _getHeaders(),
        body: json.encode({"user_id": userId, "items": items}),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Order error: $e'};
    }
  }

  Future<Map<String, dynamic>> createOrderOnBackend({
    required int userId,
    required List items,
    required String alamat,
  }) async {
    // contoh panggilan ke backend Laravel
    // ganti URL dengan endpoint backend-mu
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'items': items
            .map((e) => {'item_id': e.id, 'quantity': e.quantity})
            .toList(),
        'alamat': alamat,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal membuat order');
    }
  }

  // Favorite Items
  static Future<void> addToFavorites(String userId, int itemId) async {
    try {
      final url = '$baseUrl/favorites';
      final body = {'user_id': userId, 'item_id': itemId};

      print('=== ADD TO FAVORITES DEBUG ===');
      print('URL: $url');
      print('Body: ${json.encode(body)}');
      print('userId: $userId (type: ${userId.runtimeType})');
      print('itemId: $itemId (type: ${itemId.runtimeType})');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');
      print('=== END DEBUG ===');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Server error: ${errorBody}');
      }
    } catch (e) {
      print('EXCEPTION in addToFavorites: $e');
      rethrow;
    }
  }
  // Add these methods right after addToFavorites method

  // Get user's favorites
  static Future<List<dynamic>> getFavorites(String userId) async {
    try {
      print('Getting favorites for user: $userId');
      final response = await http.get(
        Uri.parse('$baseUrl/favorites/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Get favorites status: ${response.statusCode}');
      print('Get favorites body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print('Error getting favorites: $e');
      throw Exception('Error getting favorites: $e');
    }
  }

  // Remove from favorites
  static Future<void> removeFromFavorites(String userId, int itemId) async {
    try {
      print('Removing favorite - userId: $userId, itemId: $itemId');
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$userId/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Remove favorite status: ${response.statusCode}');
      print('Remove favorite body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      throw Exception('Error removing from favorites: $e');
    }
  }

  // Payment gateway
  static Future<Map<String, dynamic>> createOrderWithPayment({
    required int userId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      print('>>> createOrderWithPayment: userId=$userId, items=$items');
      final token = await getToken();

      final response = await http.post(
        Uri.parse("$baseUrl/orders/store"),
        headers: _getHeaders(),
        body: json.encode({"user_id": userId, "items": items}),
      );

      print('>>> Status: ${response.statusCode}');
      print('>>> Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Backend return: { success, message, data: { order_id, qr_code_url, ... } }
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          // Clean up QR URL
          String qrUrl = data['qr_code_url'].toString().replaceAll(r'\/', '/');
          print('QR Url: $qrUrl');

          // Return dengan struktur yang match dengan checkout logic
          return {
            'success': true,
            'data': {
              'qr_code_url': qrUrl,
              'order_id': data['order_id'],
              'order_code': data['order_code'],
              'total_amount': data['total_amount'],
              'status': data['status'],
            },
            'message': responseData['message'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Unknown error',
          };
        }
      } else {
        print('>>> Error Response: ${response.body}');
        return {
          'success': false,
          'message': 'Failed to create order: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('>>> createOrderWithPayment ERROR: $e');
      return {'success': false, 'message': 'Order error: $e'};
    }
  }

  // ==================== USER ENDPOINTS ====================

  static Future<int?> getUserId() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/user/cred'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['user_id'];
      }
      return null;
    } catch (e) {
      print('Error fetching userId: $e');
      return null;
    }
  }

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

  Future<List> fetchOrders(String token, String role) async {
    String url;

    if (role == 'merchant') {
      url = 'https://your-api.com/api/merchant/orders';
    } else {
      url = 'https://your-api.com/api/orders';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // list orders
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  static Future<List<dynamic>> getUserOrders(int userId) async {
    try {
      final headers = await _getHeaders(); // Ambil headers dengan token

      print('>>> getUserOrders: userId=$userId');
      print('>>> getUserOrders: headers=$headers');

      final response = await http.get(
        Uri.parse('$baseUrl/orders'), // Endpoint spesifik user
        headers: headers,
      );

      print('>>> getUserOrders: Status=${response.statusCode}');
      print('>>> getUserOrders: Body=${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final orders = data['data'] ?? [];
          print('>>> getUserOrders: Total orders=${orders.length}');
          return orders;
        }

        return [];
      } else {
        print('>>> getUserOrders: ERROR - ${response.body}');
        throw Exception('Failed to fetch orders: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('>>> getUserOrders: EXCEPTION=$e');
      print('>>> getUserOrders: Stack=$stackTrace');
      return [];
    }
  }

  // Update status pemesanan (owner)
  static Future<void> updateStatusPemesanan(int orderId, String status) async {
    try {
      final token = await getToken();

      if (token == null) {
        throw 'Token not found';
      }

      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/status-pemesanan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'status_pemesanan': status}),
      );

      print('>>> Update Status: ${response.statusCode}');
      print('>>> Update Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] != true) {
          throw data['message'] ?? 'Failed to update status';
        }
      } else {
        throw 'Failed to update status: ${response.statusCode}';
      }
    } catch (e) {
      print('>>> updateStatusPemesanan ERROR: $e');
      throw Exception('Error updating status: $e');
    }
  }

  static Future<Map<String, dynamic>?> getOrderDetail(int orderId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/orders/$orderId"),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching order detail: $e');
      return null;
    }
  }
}
