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
  
  // Search related variables
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];
  bool _isSearchLoading = false;

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tenants = await ApiService.getTenants();
      
      setState(() {
        kantinList = tenants.take(5).toList();
        _isLoading = false;
      });

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

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isSearchLoading = true;
    });

    try {
      final allItems = await ApiService.getItems();
      
      final results = allItems.where((item) {
        final itemName = item['item_name']?.toString().toLowerCase() ?? '';
        final description = item['description']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        
        return itemName.contains(searchLower) || description.contains(searchLower);
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearchLoading = false;
      });
    } catch (e) {
      setState(() {
        _isSearchLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Header username + icon
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
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

            // Search Bar - FIXED VERSION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 14),
                          cursorColor: const Color(0xFF635BFF),
                          onChanged: (value) {
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (_searchController.text == value) {
                                _performSearch(value);
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Mau makan apa hari ini",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      if (_isSearching)
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: Colors.grey,
                          onPressed: _clearSearch,
                          padding: const EdgeInsets.all(8),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content area
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isSearching
                      ? _buildSearchResults()
                      : _buildMainContent(),
            ),

            // Bottom Nav
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

  // Search Results View
  Widget _buildSearchResults() {
    if (_isSearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil untuk "${_searchController.text}"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hasil Pencarian (${_searchResults.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3.1 / 3.5,
          ),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final item = _searchResults[index];
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 125,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE6FF),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['item_name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Rp ${item['price'] ?? 0}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF635BFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Main Content View
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KANTIN TITLE
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

          // LIST KANTIN
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

          // RECOMMENDED MENU
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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