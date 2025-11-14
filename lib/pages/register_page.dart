import 'package:flutter/material.dart';
import 'login_page.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
            const Text(
              "EatO",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Nomor Telepon
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Nomor Telefen*",
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
            ),

            const SizedBox(height: 20),

            // Username
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Username",
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Password*",
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
            ),

            const SizedBox(height: 6),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
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
                onPressed: () {},
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
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
                      MaterialPageRoute(builder: (context) => const LoginPage()),
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
            )
          ],
        ),
      ),
    );
  }
}
