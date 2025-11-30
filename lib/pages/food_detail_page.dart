import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'checkout_page.dart';

class FoodDetailPage extends StatefulWidget {
  final int itemId;

  const FoodDetailPage({
    super.key,
    required this.itemId,
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  static const double _navBarHeight = 90.0;

  Map<String, dynamic>? itemData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  Future<void> fetchItem() async {
    setState(() {
      isLoading = true;
    });

    try {
      print(">>> FoodDetailPage.fetchItem: requesting id ${widget.itemId}");
      final response = await ApiService.getItemById(widget.itemId);

      // DEBUG: print raw response so we can see structure
      print(">>> FoodDetailPage.fetchItem: raw response => $response");

      // Normalize: if API returns { "data": {...} } use that, otherwise use response directly
      Map<String, dynamic>? normalized;
      if (response == null) {
        normalized = null;
      } else if (response is Map<String, dynamic> && response.containsKey('data')) {
        final d = response['data'];
        if (d is Map<String, dynamic>) {
          normalized = d;
        } else {
          normalized = null;
        }
      } else if (response is Map<String, dynamic>) {
        normalized = response;
      } else {
        normalized = null;
      }

      setState(() {
        itemData = normalized;
        isLoading = false;
      });
    } catch (e, st) {
      print(">>> FoodDetailPage.fetchItem: ERROR $e\n$st");
      if (!mounted) return;
      setState(() {
        isLoading = false;
        itemData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (itemData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text("Item not found")),
      );
    }

    // Safe getters (use preview page keys)
    final String title = itemData?['item_name']?.toString() ?? itemData?['name']?.toString() ?? '-';
    final String imageUrl = itemData?['preview_image']?.toString() ?? itemData?['image']?.toString() ?? '';
    final String description = itemData?['description']?.toString() ?? itemData?['desc']?.toString() ?? 'No description available';
    final String priceText = itemData?['price']?.toString() ?? '0';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: customBottomNavbar(0),
      body: Stack(
        children: [
          SafeArea(child: _bodyContent(context, title, imageUrl, description, priceText)),

          // ============================
          // TOMBOL KERANJANG (navigates to checkout)
          // ============================
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CheckoutPage(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4DFF),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
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
          ),
        ],
      ),
    );
  }

  // ====================================================
  // BODY CONTENT (now accepts resolved fields)
  // ====================================================
  Widget _bodyContent(BuildContext context, String title, String imageUrl, String description, String priceText) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerImage(context, title, imageUrl),
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

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Rp $priceText",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C4DFF),
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
  Widget _headerImage(BuildContext context, String title, String imageUrl) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 280,
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                )
              : Container(
                  color: const Color(0xFFEDE6FF),
                  child: const Center(
                    child: Icon(Icons.fastfood, size: 48, color: Colors.grey),
                  ),
                ),
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
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
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
