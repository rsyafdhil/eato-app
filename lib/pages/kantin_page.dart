import 'package:flutter/material.dart';

class KantinPage extends StatefulWidget {
  const KantinPage({super.key});

  @override
  State<KantinPage> createState() => _KantinPageState();
}

class _KantinPageState extends State<KantinPage> {
  final List<String> _allKantin = [
    'Toko 1','Toko 2','Toko 3','Toko 4',
    'Toko 5','Toko 6','Toko 7','Toko 8',
    'Toko 9','Toko 10','Toko 11','Toko 12',
  ];

  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final kantinToShow = _showAll ? _allKantin : _allKantin.take(8).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF635BFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kantin\nTersedia",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // BAGIAN YANG SCROLL: grid kantin
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 2, // atur proporsi kartu
                ),
                itemCount: kantinToShow.length,
                itemBuilder: (context, index) {
                  return _KantinCard(namaKantin: kantinToShow[index]);
                },
              ),
            ),

            // Tombol lihat semua + bottom nav (tidak ikut scroll)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    side: const BorderSide(color: Color(0xFF635BFF)),
                  ),
                  onPressed: () {
                    setState(() {
                      _showAll = !_showAll;
                    });
                  },
                  child: Text(
                    _showAll ? "Tampilkan sedikit" : "Lihat semua",
                    style: const TextStyle(
                      color: Color(0xFF635BFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const _BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}

class _KantinCard extends StatelessWidget {
  final String namaKantin;
  const _KantinCard({required this.namaKantin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFEDE6FF),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          namaKantin,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
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
    final bool isActive = index == 0;
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
