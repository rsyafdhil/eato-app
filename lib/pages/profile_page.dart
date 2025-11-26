import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,

      // ========= BODY =========
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // ========= HEADER PROFIL =========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO / AVATAR
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFFD9D9D9),
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 22),

                  // NAMA + NOMOR HP
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(width: 8),

                          const Icon(
                            Icons.edit,
                            size: 20,
                            color: Color(0xFF635BFF),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 55),

            // ========= USER INFORMATION TITLE =========
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "User Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ========= CARD MENU =========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _menuItem(Icons.favorite_border, "Favourites"),
                    _divider(),
                    _menuItem(Icons.person_outline, "Personal Information"),
                    _divider(),
                    _menuItem(Icons.help_outline, "Helps & Support"),
                    _divider(),
                    _menuItem(Icons.payment, "Payment"),
                    _divider(),
                    _menuItem(Icons.logout, "Log Out", isLogout: true),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ========= BOTTOM NAV =========
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFF2EAFE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _BottomNavItem(icon: Icons.home, label: "Home", index: 0),
                  _BottomNavItem(icon: Icons.receipt_long, label: "Riwayat", index: 1),
                  _BottomNavItem(icon: Icons.person, label: "Profil", index: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========= ITEM MENU =========
  Widget _menuItem(IconData icon, String title, {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isLogout ? Colors.red : Colors.black87,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.red : Colors.black87,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // ========= DIVIDER =========
  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 1,
        color: Colors.white,
      ),
    );
  }
}

// ========= BOTTOM NAV ITEM =========
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == 2;

    return Column(
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
    );
  }
}
