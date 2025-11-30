import 'package:flutter/material.dart';
// Update these imports based on where you saved cart_manager.dart
import '../services/cart_manager.dart';
import 'checkout_page.dart';

class PreviewTokoPage extends StatefulWidget {
  final String namaToko;

  const PreviewTokoPage({
    super.key,
    required this.namaToko,
  });

  @override
  State<PreviewTokoPage> createState() => _PreviewTokoPageState();
}

class _PreviewTokoPageState extends State<PreviewTokoPage> {
  int _selectedIndex = 1; // keranjang aktif
  bool _alreadyShowAll = false; // setelah true, tombol hilang
  final CartManager _cartManager = CartManager();

  final List<_MenuItem> menuList = [
    _MenuItem(id: '1', title: 'Food 1', price: 'Rp 25.000'),
    _MenuItem(id: '2', title: 'Food 2', price: 'Rp 30.000'),
    _MenuItem(id: '3', title: 'Food 3', price: 'Rp 20.000'),
    _MenuItem(id: '4', title: 'Food 4', price: 'Rp 35.000'),
    _MenuItem(id: '5', title: 'Food 5', price: 'Rp 28.000'),
    _MenuItem(id: '6', title: 'Food 6', price: 'Rp 32.000'),
    _MenuItem(id: '7', title: 'Food 7', price: 'Rp 27.000'),
    _MenuItem(id: '8', title: 'Food 8', price: 'Rp 33.000'),
  ];

  late List<_MenuItem> menuToShow;

  @override
  void initState() {
    super.initState();
    // awal: cuma 4 menu
    menuToShow = menuList.take(4).toList();
  }

  void _addToCart(_MenuItem item) {
    setState(() {
      _cartManager.addToCart(item.id, item.title, item.price);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF635BFF),
      ),
    );
  }

  void _toggleFavorite(_MenuItem item) {
    setState(() {
      _cartManager.toggleFavorite(item.id, item.title, item.price);
    });
    
    final isFav = _cartManager.isFavorite(item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav 
            ? '${item.title} ditambahkan ke favorit' 
            : '${item.title} dihapus dari favorit'
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: isFav ? Colors.pink : Colors.grey,
      ),
    );
  }

  void _goToCheckout() {
    if (_cartManager.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang masih kosong'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutPage(),
      ),
    ).then((_) {
      // Refresh state setelah kembali dari checkout
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // === KONTEN UTAMA ===
            Column(
              children: [
                // HEADER
                SizedBox(
                  height: size.height * 0.22,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEDE6FF),
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
                      // BACK
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
                            const Text(
                              'Desc toko',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ISI SCROLLABLE
                Expanded(
                  child: SingleChildScrollView(
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
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4.2,
                          ),
                          itemCount: menuToShow.length,
                          itemBuilder: (context, index) {
                            final item = menuToShow[index];
                            final isFavorite = _cartManager.isFavorite(item.id);
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar makanan dengan Love Button
                                Stack(
                                  children: [
                                    Container(
                                      height: 110,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE6FF),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 40,
                                          color: Color(0xFF635BFF),
                                        ),
                                      ),
                                    ),
                                    // Love Button
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => _toggleFavorite(item),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isFavorite 
                                              ? Icons.favorite 
                                              : Icons.favorite_border,
                                            color: isFavorite 
                                              ? Colors.pink 
                                              : Colors.grey,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Nama makanan
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 2),

                                // Price
                                Text(
                                  item.price,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Tombol Add to Cart
                                SizedBox(
                                  width: double.infinity,
                                  height: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF635BFF),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => _addToCart(item),
                                    child: const Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // TOMBOL LIHAT SEMUA
                        if (!_alreadyShowAll)
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
                                  menuToShow = List<_MenuItem>.from(menuList);
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

            // === TOMBOL KERANJANG MELAYANG ===
            Positioned(
              left: 0,
              right: 0,
              bottom: 82,
              child: Center(
                child: GestureDetector(
                  onTap: _goToCheckout,
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
                        const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Keranjang (${_cartManager.getTotalItems()})',
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

            // === BOTTOM NAV ===
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
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
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
}

// ===== MODEL DATA =====
class _MenuItem {
  final String id;
  final String title;
  final String price;
  
  _MenuItem({
    required this.id,
    required this.title,
    required this.price,
  });
}

// ===== BOTTOM NAV ITEM =====
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    super.key,
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
                color: isActive ? const Color(0xFF635BFF) : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}