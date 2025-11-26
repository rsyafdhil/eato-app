import 'package:flutter/material.dart';
import 'kantin_page.dart';
import 'preview_toko_page.dart';

class HomePage extends StatelessWidget {
  final String username; // <-- tambah field

  const HomePage({
    super.key,
    required this.username, // <-- wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    // dummy data kantin dan menu
    final List<String> kantinList = [
      'Toko 1',
      'Toko 2',
      'Toko 3',
      'Toko 4',
      'Toko 5',
    ];

    final List<_MenuItem> recommendedMenu = [
      _MenuItem(title: 'Food 1', toko: 'Toko 1'),
      _MenuItem(title: 'Food 2', toko: 'Toko 4'),
      _MenuItem(title: 'Food 3', toko: 'Toko 6'),
      _MenuItem(title: 'Food 1', toko: 'Toko 2'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ============ SPASI DARI ATAS 84px ============
            const SizedBox(height: 84),

            // ======== HEADER + ICON FAVORIT ========
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Hello 👋, $username!",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.favorite_border,
                    size: 24,
                  ),
                ],
              ),
            ),

            // ======== SEARCH BAR ========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Mau makan apa hari ini",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ======== ISI SCROLLABLE ========
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======== SECTION KANTIN ========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Kantin",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const KantinPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "Lihat semua",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF635BFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Color(0xFF635BFF),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        itemCount: kantinList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final nama = kantinList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PreviewTokoPage(namaToko: nama),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 110,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE6FF),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  nama,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ======== SECTION RECOMMENDED MENU ========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recommended Menu",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),

                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 3.1 / 3.5,
                            ),
                            itemCount: recommendedMenu.length,
                            itemBuilder: (context, index) {
                              final item = recommendedMenu[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PreviewTokoPage(
                                          namaToko: item.toko),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 125,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE6FF),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      item.toko,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ======== BOTTOM NAV ========
            const _BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}

// model kecil buat menu
class _MenuItem {
  final String title;
  final String toko;

  _MenuItem({required this.title, required this.toko});
}

// bottom nav (Home aktif)
class _BottomNavBar extends StatelessWidget {
  final int currentIndex; // 0: Home, 1: Riwayat, 2: Profil

  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

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
    final bool isActive = index == 0; // yang aktif: Home

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
