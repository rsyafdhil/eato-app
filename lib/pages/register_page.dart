import 'dart:convert';

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  final String title; // Judul Halaman
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nomorTelefonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  Future<void> register() async {
    final registerApi = "http://localhost:8000/api/register";
    final response = await http.post(
      Uri.parse(registerApi),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': passwordConfirmationController.text,
        'nomor_telefon': nomorTelefonController.text,
        'name': nameController.text,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      // Contoh format respons Laravel:
      // { "success": true, "message": "Login berhasil" }

      if (data['success'] == true) {
        // 👉 Pindah ke halaman daftar_kantin
        Navigator.pushNamed(context, '/daftar_kantin');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Register gagal')),
        );
      }
    } else if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Validasi gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Title EatO
            Text(
              widget.title,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Nomor Telepon
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Nomor Telefon*",
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "Nomer Telepon",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: nomorTelefonController,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Username
            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Username", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: nameController,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            // email
            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Email", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: emailController,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Password
            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Password*", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 6),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: passwordController,
              style: const TextStyle(fontSize: 14),
            ),

            // Password Confirmation
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Password Confirmation*",
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: passwordConfirmationController,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 6),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),

            const SizedBox(height: 25),

            // Sign Up button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: register,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Already have account?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account?"),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign in!",
                    style: const TextStyle(
                      color: Color(0xFF635BFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
