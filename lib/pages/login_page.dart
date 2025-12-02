import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    // Validate input
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        final token = result['access_token'] ?? result['data']?['token'];
        if (token != null) {
          await prefs.setString('token', token);
          print('✅ Token tersimpan');
          print(token);
          ApiService.setToken(token);
          print('token set : $token');

          final checkToken = ApiService.getToken();
          print('get token : $token');
        }

        // ✅ Coba dua kemungkinan struktur
        final userData = result['user'] ?? result['data']?['user'];

        print('📦 User Data: $userData');

        if (userData != null) {
          // Simpan role
          if (userData['role'] != null && userData['role']['name'] != null) {
            final roleName = userData['role']['name'].toString().toLowerCase();
            await prefs.setString('user_role', roleName);
            print('✅ Role tersimpan: $roleName');
          }

          // Simpan tenant_id
          if (userData['tenant_id'] != null) {
            await prefs.setInt('tenant_id', userData['tenant_id']);
            print('✅ Tenant ID: ${userData['tenant_id']}');
          }

          // Simpan user info
          await prefs.setInt('user_id', userData['id']);
          await prefs.setString('user_name', userData['name'] ?? '');
          await prefs.setString('user_email', userData['email'] ?? '');
        }

        // Simpan token

        // ✅ AMBIL username & phoneNumber dari userData
        final username = userData?['name'] ?? 'User';
        final phoneNumber = userData?['nomor_telefon'] ?? '';

        // Navigate
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomePage(username: username, phoneNumber: phoneNumber),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              const Text(
                "EatO",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 60),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Password", style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "New user? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegisterPage(title: "EatO"),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up!",
                      style: TextStyle(
                        color: Color(0xFF6A5CFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
