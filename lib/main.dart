import 'package:flutter/material.dart';
import 'pages/checkout_page.dart';
import 'pages/riwayat_transaksi_page.dart';
import 'pages/kantin_page.dart';
import 'pages/register_page.dart';
import 'pages/login_page.dart';
import 'pages/preview_toko_page.dart';
import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'pages/food_detail_page.dart';
import 'pages/form_update_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatO App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF635BFF)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(title: "EatO"),
        '/home': (context) => const MyHomePage(),
        '/daftar_kantin': (context) => const KantinPage(
          username: 'Guest',  // Added
          phoneNumber: '0000000000',  // Added
        ),
        '/checkout': (context) => const CheckoutPage(),
        '/homepage': (context) => const HomePage(
              username: 'username',
              phoneNumber: 'phoneNumber',
            ),
        '/preview': (context) => const PreviewTokoPage(
              namaToko: 'Gacor',
              tenantId: 1,
              username: 'Guest',
              phoneNumber: '0000000000',
            ),
        '/profile': (context) => const ProfilePage(
              username: 'saga',
              phoneNumber: '08943475832',
            ),
        '/favorites': (context) => const FavoritePage(
              username: 's',
              phoneNumber: 'phoneNumber',
            ),
        '/food': (context) => const FoodDetailPage(
              itemId: 1,
            ),
        '/form': (context) => const FormUpdatePage(
              username: 'username',
              phoneNumber: 'phoneNumber',
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = "EatO"});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(child: Text("Berhasil login!")),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}