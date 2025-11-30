import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'preview_toko_page.dart';

class KantinPage extends StatefulWidget {
  const KantinPage({super.key});

  @override
  State<KantinPage> createState() => _KantinPageState();
}

class _KantinPageState extends State<KantinPage> {
  List<dynamic> _allKantin = [];
  bool _isLoading = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  Future<void> _loadTenants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tenants = await ApiService.getTenants();
      setState(() {
        _allKantin = tenants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tenants: $e')),
      );
    }
  }

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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
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

            // LOADING OR CONTENT
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _allKantin.isEmpty
                      ? const Center(
                          child: Text('No tenants available'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: kantinToShow.length,
                          itemBuilder: (context, index) {
                            final kantin = kantinToShow[index];
                            return _KantinCard(
                              id: kantin['id'],
                              namaKantin: kantin['name'] ?? 'Unknown',
                              previewImage: kantin['preview_image'],
                            );
                          },
                        ),
            ),

            // Tombol lihat semua + bottom nav
            if (!_isLoading && _allKantin.length > 8)
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
  final int id;
  final String namaKantin;
  final String? previewImage;

  const _KantinCard({
    required this.id,
    required this.namaKantin,
    this.previewImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PreviewTokoPage(
              tenantId: id,
              namaToko: namaKantin,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE6FF),
              borderRadius: BorderRadius.circular(16),
              image: previewImage != null
                  ? DecorationImage(
                      image: NetworkImage(previewImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: previewImage == null
                ? const Center(
                    child: Icon(
                      Icons.store,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            namaKantin,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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