import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../services/cart_manager.dart';
import 'food_detail_page.dart';
import 'checkout_page.dart';

class PreviewTokoPage extends StatefulWidget {
  final int tenantId;
  final String namaToko;

  const PreviewTokoPage({
    super.key,
    required this.tenantId,
    required this.namaToko,
  });

  @override
  State<PreviewTokoPage> createState() => _PreviewTokoPageState();
}

class _PreviewTokoPageState extends State<PreviewTokoPage> {
  int _selectedIndex = 1;
  bool _alreadyShowAll = false;
  bool _isLoading = true;
  List<dynamic> menuList = [];
  List<dynamic> menuToShow = [];
  Map<String, dynamic>? tenantData;
  String? errorMessage;
  
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    _loadTenantData();
  }

  Future<void> _loadTenantData() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      print('Loading tenant ID: ${widget.tenantId}');
      
      final tenant = await ApiService.getTenantById(widget.tenantId);
      print('Tenant data: $tenant');
      
      final items = await ApiService.getItemsByTenant(widget.tenantId);
      print('Items count: ${items.length}');
      print('Items data: $items');

      if (!mounted) return;

      setState(() {
        tenantData = tenant;
        menuList = items;
        menuToShow = items.length > 4 ? items.take(4).toList() : items;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        errorMessage = e.toString();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartItemCount = _cartManager.getTotalItems();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // HEADER
                SizedBox(
                  height: size.height * 0.22,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE6FF),
                          image: tenantData?['preview_image'] != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    tenantData!['preview_image'],
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) {
                                    print('Error loading image: $error');
                                  },
                                )
                              : null,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: size.height * 0.11,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.0),
                                  Colors.black.withOpacity(0.55),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // BACK BUTTON
                      Positioned(
                        top: 12,
                        left: 12,
                        child: GestureDetector(
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
                      ),
                      // NAMA TOKO
                      Positioned(
                        left: 16,
                        bottom: 18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.namaToko,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tenantData?['description']?.toString() ?? 'Desc toko',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ISI SCROLLABLE
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Failed to load data',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _loadTenantData,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // GRID MENU
                                  menuList.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(32.0),
                                            child: Column(
                                              children: [
                                                const Icon(
                                                  Icons.restaurant_menu,
                                                  size: 64,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 16),
                                                const Text(
                                                  'No items available',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Tenant ID: ${widget.tenantId}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 3 / 3.5,
                                          ),
                                          itemCount: menuToShow.length,
                                          itemBuilder: (context, index) {
                                            final item = menuToShow[index];
                                            return _buildMenuItem(item);
                                          },
                                        ),

                                  const SizedBox(height: 12),

                                  // TOMBOL LIHAT SEMUA
                                  if (!_alreadyShowAll && menuList.length > 4)
                                    SizedBox(
                                      width: double.infinity,
                                      height: 42,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFF635BFF),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            menuToShow = List.from(menuList);
                                            _alreadyShowAll = true;
                                          });
                                        },
                                        child: const Text(
                                          'Lihat semua',
                                          style: TextStyle(
                                            color: Color(0xFF635BFF),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 90),
                                ],
                              ),
                            ),
                ),
              ],
            ),

            // TOMBOL KERANJANG MELAYANG
            Positioned(
              left: 0,
              right: 0,
              bottom: 82,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (cartItemCount > 0) {
                      // Navigate to checkout page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      ).then((_) {
                        // Refresh the page when returning from checkout
                        setState(() {});
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Keranjang masih kosong!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF635BFF),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                            // Badge for cart count
                            if (cartItemCount > 0)
                              Positioned(
                                right: -8,
                                top: -8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    cartItemCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cartItemCount > 0 
                              ? 'Keranjang ($cartItemCount)'
                              : 'Keranjang',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // BOTTOM NAV
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BottomNavItem(
                      icon: Icons.home,
                      label: 'Home',
                      index: 0,
                      isActive: _selectedIndex == 0,
                      onTap: () => Navigator.pop(context),
                    ),
                    _BottomNavItem(
                      icon: Icons.receipt_long,
                      label: 'Riwayat',
                      index: 2,
                      isActive: _selectedIndex == 2,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                    _BottomNavItem(
                      icon: Icons.person,
                      label: 'Profil',
                      index: 3,
                      isActive: _selectedIndex == 3,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    final imageUrl = item['preview_image']?.toString();
    final int itemId = int.parse(item['id'].toString());
    final String itemIdStr = item['id'].toString();
    final String itemName = item['item_name']?.toString() ?? 'Unknown';
    final String price = item['price']?.toString() ?? '0';
      
    return InkWell(
      onTap: () {
        // GO TO FOOD DETAIL
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(itemId: itemId),
          ),
        ).then((_) {
          // Refresh when returning from detail page
          setState(() {});
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE6FF),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: imageUrl != null && imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? const Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 40,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),

                // FAVORITE BUTTON
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _cartManager.toggleFavorite(itemIdStr, itemName, price);
                      });
                      
                      final isFav = _cartManager.isFavorite(itemIdStr);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav 
                                ? 'Ditambahkan ke favorit' 
                                : 'Dihapus dari favorit'
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _cartManager.isFavorite(itemIdStr)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: const Color(0xFF635BFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // INFO
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Rp $price',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF635BFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ADD TO CART BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        _cartManager.addToCart(itemIdStr, itemName, price);
                        setState(() {}); // Refresh to update cart count
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$itemName ditambahkan ke keranjang!',
                            ),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Lihat',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CheckoutPage(),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF635BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? const Color(0xFF635BFF) : Colors.grey.shade600,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color:
                    isActive ? const Color(0xFF635BFF) : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}