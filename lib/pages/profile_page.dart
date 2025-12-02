import 'package:flutter/material.dart';
import 'riwayat_transaksi_page.dart';
import 'home_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String phoneNumber;

  const ProfilePage({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF), // background lembut
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // ===================== AVATAR =====================
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 60, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // ===================== USERNAME =====================
            Text(
              username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              "$username@example.com",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // ===================== STAT BOX =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statCard("16", "Orders", const Color(0xFFBFA5FF)),
                  _statCard("3", "Favorites", const Color(0xFFECEAFF)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ===================== MENU CARD =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _menuItem(Icons.person, "Profile", "Edit Profile"),
                    const Divider(height: 25),
                    _menuItem(Icons.favorite, "Favorites", "Favorites"),
                    const Divider(height: 25),
                    _menuItem(
                      Icons.logout,
                      "Log Out",
                      "Log out",
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ===================== BOTTOM NAV (TIDAK DIUBAH) =====================
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFF2EAFE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomNavItem(
                    icon: Icons.home,
                    label: "Home",
                    index: 0,
                    username: username,
                    phoneNumber: phoneNumber,
                  ),
                  _BottomNavItem(
                    icon: Icons.receipt_long,
                    label: "Riwayat",
                    index: 1,
                    username: username,
                    phoneNumber: phoneNumber,
                  ),
                  _BottomNavItem(
                    icon: Icons.person,
                    label: "Profil",
                    index: 2,
                    username: username,
                    phoneNumber: phoneNumber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== STAT ITEM WIDGET =====================
  Widget _statCard(String number, String label, Color bgColor) {
    return Container(
      width: 95,
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ===================== MENU ITEM WIDGET =====================
  Widget _menuItem(
    IconData icon,
    String title,
    String subtitle, {
    bool isLogout = false,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: isLogout
              ? Colors.black
              : (title == "Favorites"
                    ? const Color(0xFFE8D7FF)
                    : const Color(0xFFFFCE8A)),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isLogout ? Colors.black : Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    );
  }
}

// ===================== BOTTOM NAV CLASS (TIDAK DIUBAH) =====================
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final String username;
  final String phoneNumber;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.username,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = index == 2;

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  HomePage(username: username, phoneNumber: phoneNumber),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RiwayatTransaksiPage(
                username: username,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? const Color(0xFF635BFF) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color(0xFF635BFF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
