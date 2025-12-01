import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../services/cart_manager.dart';
import 'food_detail_page.dart';
import 'checkout_page.dart';
import 'favorites_page.dart';

class PreviewTokoPage extends StatefulWidget {
  final int tenantId;
  final String namaToko;
  final String username;
  final String phoneNumber;

  const PreviewTokoPage({
    super.key,
    required this.tenantId,
    required this.namaToko,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<PreviewTokoPage> createState() => _PreviewTokoPageState();
}

class _PreviewTokoPageState extends State<PreviewTokoPage> {
  int _selectedIndex = 1;
  bool _alreadyShowAll = false;
  bool _isLoading = true;
  String _selectedCategory = 'Makanan'; // Default category
  List<dynamic> allMenuList = []; // Store all items
  List<dynamic> filteredMenuList = []; // Store filtered items by category
  List<dynamic> menuToShow = []; // Items to display (with limit)
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
        allMenuList = items;
        _filterMenuByCategory();
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

  void _filterMenuByCategory() {
    print('Filtering by category: $_selectedCategory');
    print('Total items: ${allMenuList.length}');
    
    // Filter items based on selected category
    filteredMenuList = allMenuList.where((item) {
      // Access the category_name from the category object
      final categoryObj = item['category'];
      final categoryName = categoryObj != null 
          ? (categoryObj['category_name']?.toString().toLowerCase() ?? '')
          : '';
      final selectedCat = _selectedCategory.toLowerCase();
      
      print('Item: ${item['item_name']}, Category Name: $categoryName, Match: ${categoryName == selectedCat}');
      
      return categoryName == selectedCat;
    }).toList();

    print('Filtered items count: ${filteredMenuList.length}');

    setState(() {
      _alreadyShowAll = false;
      menuToShow = filteredMenuList.length > 4 
          ? filteredMenuList.take(4).toList() 
          : filteredMenuList;
    });
  }

  void _switchCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterMenuByCategory();
    });
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

                // CATEGORY TABS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _CategoryTab(
                          label: 'Makanan',
                          isSelected: _selectedCategory == 'Makanan',
                          onTap: () => _switchCategory('Makanan'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CategoryTab(
                          label: 'Minuman',
                          isSelected: _selectedCategory == 'Minuman',
                          onTap: () => _switchCategory('Minuman'),
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
                                  Text(
                                    'Menu $_selectedCategory',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Debug info (remove this in production)
                                  if (allMenuList.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Total: ${allMenuList.length} | $_selectedCategory: ${filteredMenuList.length}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),

                                  // GRID MENU
                                  filteredMenuList.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(32.0),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  _selectedCategory == 'Makanan' 
                                                      ? Icons.restaurant_menu 
                                                      : Icons.local_cafe,
                                                  size: 64,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  'Tidak ada $_selectedCategory tersedia',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                if (allMenuList.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Text(
                                                      'Coba kategori lain',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade600,
                                                      ),
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
                                  if (!_alreadyShowAll && filteredMenuList.length > 4)
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
                                            menuToShow = List.from(filteredMenuList);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      ).then((_) {
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(itemId: itemId),
          ),
        ).then((_) {
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: FutureBuilder<List<dynamic>>(
                    future: ApiService.getFavorites(widget.phoneNumber),
                    builder: (context, snapshot) {
                      final isFav = snapshot.hasData &&
                          snapshot.data!.any((fav) => fav['id'].toString() == itemIdStr);

                      return GestureDetector(
                        onTap: () async {
                          try {
                            if (isFav) {
                              await ApiService.removeFromFavorites(
                                widget.phoneNumber,
                                itemId,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Dihapus dari favorit'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              await ApiService.addToFavorites(
                                widget.phoneNumber,
                                itemId,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Ditambahkan ke favorit'),
                                  duration: const Duration(seconds: 1),
                                  action: SnackBarAction(
                                    label: 'Lihat',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FavoritePage(
                                            username: widget.username,
                                            phoneNumber: widget.phoneNumber,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                            setState(() {});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: const Color(0xFF635BFF),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

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
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        _cartManager.addToCart(itemIdStr, itemName, price);
                        setState(() {});
                        
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

// Category Tab Widget
class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF635BFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF635BFF) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
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