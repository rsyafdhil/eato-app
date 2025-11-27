import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  final String description;

  const FoodDetailPage({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  static const double _navBarHeight = 90.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: customBottomNavbar(0),
      body: Stack(
        children: [
          SafeArea(child: _bodyContent(context)),

          // ============================
          // TOMBOL KERANJANG
          // ============================
          Positioned(
            bottom: 20, // posisi sudah sama dengan halaman toko
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4DFF),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Keranjang",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // BODY CONTENT
  // ====================================================
  Widget _bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerImage(context),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Komentar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),
          _commentItem(),
          _commentItem(),
          const SizedBox(height: 20),

          // INPUT KOMENTAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Masukkan komentar",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // TOMBOL KIRIM
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C63FF),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Kirim",
                  style: TextStyle(
                    color: Colors.white, // FIX: putih
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 140),
        ],
      ),
    );
  }

  // ====================================================
  // HEADER GAMBAR
  // ====================================================
  Widget _headerImage(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 280,
          child: Image.asset(image, fit: BoxFit.cover),
        ),

        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),

        Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.arrow_back, size: 24),
            ),
          ),
        ),

        Positioned(
          bottom: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Nama Toko",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ====================================================
  // ITEM KOMENTAR
  // ====================================================
  Widget _commentItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              SizedBox(width: 12),
              Text(
                "Farhan Daffa D",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer magna justo.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 25),
        ],
      ),
    );
  }

  // ====================================================
  // NAVBAR
  // ====================================================
  Widget customBottomNavbar(int selectedIndex) {
    return Container(
      height: _navBarHeight,
      decoration: BoxDecoration(
        color: const Color(0xffF6F2FF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(
              icon: Icons.home_filled,
              label: "Home",
              isActive: selectedIndex == 0),
          _navItem(
              icon: Icons.receipt_long,
              label: "Riwayat",
              isActive: selectedIndex == 1),
          _navItem(
              icon: Icons.person,
              label: "Profil",
              isActive: selectedIndex == 2),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: isActive ? const EdgeInsets.all(8) : EdgeInsets.zero,
          decoration: isActive
              ? BoxDecoration(
                  color: const Color(0xffE5DBFF),
                  borderRadius: BorderRadius.circular(30),
                )
              : null,
          child: Icon(
            icon,
            size: 28,
            color: isActive ? const Color(0xff4B3FFF) : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xff4B3FFF) : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
