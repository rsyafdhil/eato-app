import 'package:flutter/material.dart';
import 'kantin_page.dart';
import 'preview_toko_page.dart';
import 'profile_page.dart';
import 'riwayat_transaksi_page.dart';
import '../services/api_services.dart';
import 'food_detail_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String phoneNumber;

  const HomePage({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> kantinList = [];
  List<dynamic> recommendedMenu = [];
  bool _isLoading = true;
  String getTenantName(int tenantId) {
  final tenant = kantinList.firstWhere(
    (t) => t['id'] == tenantId,
    orElse: () => null,
  );

  return tenant != null ? tenant['name'] : 'Unknown';
}

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tenants = await ApiService.getTenants();
      
      setState(() {
        kantinList = tenants.take(5).toList(); // Show first 5 tenants
        _isLoading = false;
      });

      // Load items from first tenant for recommended menu
      if (tenants.isNotEmpty) {
        final items = await ApiService.getItemsByTenant(tenants[0]['id']);
        setState(() {
          recommendedMenu = items.take(4).toList();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 84),

                  /// Header username + icon
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Hello 👋, ${widget.username}!",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Make favorite icon clickable
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FavoritePage(
                                  username: widget.username,
                                  phoneNumber: widget.phoneNumber,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2EAFE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              size: 24,
                              color: Color(0xFF635BFF),
                            ),
                          ),
                        ),
                      ],
                    ),
),

            /// Search Bar
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      child: const Icon(Icons.search, size: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    /// KANTIN TITLE
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
                                  builder: (_) => KantinPage(
                                    username: widget.username,
                                    phoneNumber: widget.phoneNumber,
                                  ),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                Icon(Icons.arrow_forward,
                                    size: 16, color: Color(0xFF635BFF)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// LIST KANTIN
                    SizedBox(
                      height: 110,
                      child: kantinList.isEmpty
                          ? const Center(child: Text('No tenants available'))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              itemCount: kantinList.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final kantin = kantinList[index];
                                final nama = kantin['name'] ?? 'Unknown';
                                final tenantId = kantin['id'] ?? 0;
                                final previewImage = kantin['preview_image'];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PreviewTokoPage(
                                          namaToko: nama,
                                          tenantId: tenantId,
                                          username: widget.username,
                                          phoneNumber: widget.phoneNumber,
                                        ),
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
                                          image: previewImage != null
                                              ? DecorationImage(
                                                  image: NetworkImage(previewImage),
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
                                        nama,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 24),

                    /// RECOMMENDED MENU
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
                            physics: const NeverScrollableScrollPhysics(),
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
                                        builder: (_) => FoodDetailPage(
                                          itemId: item['id'],                    
                                        ),
                                      ),
                                    );
                                  },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 125,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE6FF),
                                        borderRadius: BorderRadius.circular(16),
                                        image: item['preview_image'] != null
                                            ? DecorationImage(
                                                image: NetworkImage(item['preview_image']),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: item['preview_image'] == null
                                          ? const Center(
                                              child: Icon(
                                                Icons.fastfood,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['item_name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      'Rp ${item['price'] ?? 0}',
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

            /// BOTTOM NAV
            _BottomNavBar(
              currentIndex: 0,
              username: widget.username,
              phoneNumber: widget.phoneNumber,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String username;
  final String phoneNumber;

  const _BottomNavBar({
    required this.currentIndex,
    required this.username,
    required this.phoneNumber,
  });

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
        children: [
          _BottomNavItem(
            icon: Icons.home,
            label: "Home",
            index: 0,
            isActive: currentIndex == 0,
            onTap: () {},
          ),
          _BottomNavItem(
            icon: Icons.receipt_long,
            label: "Riwayat",
            index: 1,
            isActive: currentIndex == 1,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => RiwayatTransaksiPage(
                    username: username,
                    phoneNumber: phoneNumber,
                  ),
                ),
              );
            },
          ),
          _BottomNavItem(
            icon: Icons.person,
            label: "Profil",
            index: 2,
            isActive: currentIndex == 2,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    username: username,
                    phoneNumber: phoneNumber,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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