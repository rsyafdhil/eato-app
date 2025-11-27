import 'package:eato_app/pages/kantin_page.dart';
import 'package:eato_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'pages/checkout_page.dart';
import 'pages/riwayat_transaksi_page.dart';
import 'pages/kantin_page.dart';
import 'pages/register_page.dart';
import 'pages/login_page.dart';
import 'pages/preview_toko_page.dart';
import 'pages/home_page.dart';
import 'package:flutter/material.dart';
import 'pages/favorites_page.dart';
import 'pages/food_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/favorites',
      // home: const LoginPage(),
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(title: "EatO"),
        '/home': (context) => const MyHomePage(),
        '/daftar_kantin': (context) => const KantinPage(),
        '/checkout' : (context) => const CheckoutPage(),
        '/homepage' : (context) => const HomePage(username: 'username', phoneNumber: 'phoneNumber'),
        '/preview' : (context) => const PreviewTokoPage(namaToko: 'Gacor'),
        '/profile' : (context) => const ProfilePage(username: 'saga', phoneNumber: '08943475832'),
        '/favorites' : (context) => const FavoritePage(username: 's', phoneNumber: 'phoneNumber'),
        '/food' : (context) => const FoodDetailPage(name: 'Nasi Kebuli', image: '', price: 'Rp 12.000', description: 'Makanan Gacor'),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = "EatO"});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  final String title;
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(child: Text("Berhasil login!")),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
