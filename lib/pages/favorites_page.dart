import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';

class FavoritePage extends StatefulWidget {
  final String username;
  final String phoneNumber;

  const FavoritePage({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> favoriteList = [
    {'title': 'Makanan #1', 'store': 'Toko', 'price': 'Harga'},
    {'title': 'Makanan #1', 'store': 'Toko', 'price': 'Harga'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // NAVBAR FIX
      bottomNavigationBar: _bottomNavBar(),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BACK BUTTON & HEADER
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(
                            username: widget.username,
                            phoneNumber: widget.phoneNumber,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF635BFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Title
                  const Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Favorit Anda",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // LIST / EMPTY VIEW
            Expanded(
              child: favoriteList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada makanan favorit",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      itemCount: favoriteList.length,
                      itemBuilder: (context, index) {
                        final item = favoriteList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Image Placeholder dengan margin kiri 5px
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0E0E0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Text Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['store'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      item['price'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Favorite Icon dengan margin kanan 5px
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // NAVBAR (TIDAK DIUBAH UI-NYA)
  Widget _bottomNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home, "Home", 0),
          _navItem(Icons.favorite, "Favorite", 1),
          _navItem(Icons.person, "Profile", 2),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final active = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == _selectedIndex) return;

        setState(() => _selectedIndex = index);

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(
                username: widget.username,
                phoneNumber: widget.phoneNumber,
              ),
            ),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(
                username: widget.username,
                phoneNumber: widget.phoneNumber,
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 26,
            color: active ? const Color(0xFF635BFF) : Colors.grey.shade600,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? const Color(0xFF635BFF) : Colors.grey.shade600,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}