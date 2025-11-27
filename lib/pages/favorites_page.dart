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
    {'title': 'Food 1', 'price': 'Rp 12.000'},
    {'title': 'Food 2', 'price': 'Rp 15.000'},
    {'title': 'Food 3', 'price': 'Rp 18.000'},
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
            // HEADER
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Favorite",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // LIST / EMPTY VIEW
            Expanded(
              child: favoriteList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada makanan favorit",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 3.5,
                      ),
                      itemCount: favoriteList.length,
                      itemBuilder: (context, index) {
                        final item = favoriteList[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE6FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              item['price'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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
