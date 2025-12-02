import 'package:flutter/material.dart';
import '../services/cart_manager.dart';
import 'qr_payment_page.dart';
import '../services/api_services.dart';
import '../services/cart_manager.dart';
import '../services/midtrans_services.dart';
import '../models/tenant_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartManager _cartManager = CartManager();
  final TextEditingController _alamatController = TextEditingController();
  String _savedAlamat = '';

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  void _updateQuantity(String id, int newQty) {
    setState(() {
      _cartManager.updateQuantity(id, newQty);
    });
  }

  double _calculateSubtotal() {
    double total = 0;
    for (var item in _cartManager.cartItems) {
      // Extract number from price string (e.g., "Rp 25.000" -> 25000)
      String priceStr = item.price.replaceAll(RegExp(r'[^0-9]'), '');
      double price = double.tryParse(priceStr) ?? 0;
      total += price * item.quantity;
    }
    return total;
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final deliveryFee = 5000.0;
    final serviceFee = 2000.0;
    final tax = subtotal * 0.1; // 10% tax
    final total = subtotal + deliveryFee + serviceFee + tax;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Tombol back
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Checkout\nPesananmu!",
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Isi scrollable
            Expanded(
              child: _cartManager.cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Keranjang kosong',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul Pesanan
                          const Text(
                            'Pesanan Anda',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // List produk dari cart
                          ...List.generate(_cartManager.cartItems.length, (
                            index,
                          ) {
                            final item = _cartManager.cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _CheckoutProductCard(
                                productName: item.title,
                                priceText: item.price,
                                qty: item.quantity,
                                onIncrement: () {
                                  _updateQuantity(item.id, item.quantity + 1);
                                },
                                onDecrement: () {
                                  _updateQuantity(item.id, item.quantity - 1);
                                },
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          // Card Tujuan
                          _AlamatCard(
                            controller: _alamatController,
                            savedAlamat: _savedAlamat,
                            onSave: () {
                              setState(() {
                                _savedAlamat = _alamatController.text;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Alamat disimpan'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color(0xFF635BFF),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Card Fee
                          _FeeCard(
                            subtotal: subtotal,
                            deliveryFee: deliveryFee,
                            serviceFee: serviceFee,
                            tax: tax,
                            total: total,
                            formatCurrency: _formatCurrency,
                          ),

                          const SizedBox(height: 24),

                          // Tombol Bayar
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF635BFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                if (_savedAlamat.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Silakan isi alamat terlebih dahulu',
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                // Show loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                try {
                                  final userId = await ApiService.getUserId();

                                  if (userId == null) {
                                    throw 'Gagal mengambil userId';
                                  }

                                  final items = _cartManager.cartItems.map((
                                    item,
                                  ) {
                                    return {
                                      'item_id': int.parse(item.id),
                                      'quantity': item.quantity,
                                    };
                                  }).toList();

                                  final result =
                                      await ApiService.createOrderWithPayment(
                                        userId: userId,
                                        items: items,
                                        alamat: _alamatController.text,
                                      );

                                  print(
                                    '>>> Checkout Result: $result',
                                  ); // Debug

                                  Navigator.pop(context); // Close loading

                                  // Cek apakah berhasil
                                  if (result['success'] == true &&
                                      result['data'] != null) {
                                    final qrCodeUrl =
                                        result['data']['qr_code_url'];
                                    final orderId = result['data']['order_id'];

                                    // Validasi data
                                    if (qrCodeUrl == null || orderId == null) {
                                      throw 'QR Code URL atau Order ID tidak ditemukan';
                                    }

                                    // Buka halaman QR payment
                                    final paymentSuccess = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QrPaymentPage(
                                          qrCodeUrl: qrCodeUrl,
                                          orderId: orderId,
                                          totalAmount: total,
                                        ),
                                      ),
                                    );

                                    if (paymentSuccess == true) {
                                      _cartManager.clearCart();
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Pembayaran berhasil!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } else {
                                    // Handle error
                                    final message =
                                        result['message'] ??
                                        'Terjadi kesalahan';
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $message'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }

                                  print('>>> Checkout Error: $e'); // Debug
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Bayar ${_formatCurrency(total)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),

            // Bottom navigation dummy
            const _BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}

class _CheckoutProductCard extends StatelessWidget {
  final String productName;
  final String priceText;
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CheckoutProductCard({
    required this.productName,
    required this.priceText,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = qty > 0;
    const Color activeColor = Color(0xFF635BFF);
    final Color disabledColor = Colors.grey.shade300;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Placeholder gambar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fastfood,
              color: Color(0xFF635BFF),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          // Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  priceText,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),

                // Baris + Qty -
                Row(
                  children: [
                    // Tombol +
                    GestureDetector(
                      onTap: onIncrement,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Teks Qty (angka)
                    Text(
                      qty.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Tombol -
                    GestureDetector(
                      onTap: canDecrement ? onDecrement : null,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: canDecrement ? activeColor : disabledColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: canDecrement ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlamatCard extends StatelessWidget {
  final TextEditingController controller;
  final String savedAlamat;
  final VoidCallback onSave;

  const _AlamatCard({
    required this.controller,
    required this.savedAlamat,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tujuan",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Masukkan alamat anda",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF635BFF)),
              ),
            ),
          ),
          if (savedAlamat.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Color(0xFF635BFF),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      savedAlamat,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onSave,
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double total;
  final String Function(double) formatCurrency;

  const _FeeCard({
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tax,
    required this.total,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _FeeRow(label: 'Subtotal', value: formatCurrency(subtotal)),
          const SizedBox(height: 4),
          _FeeRow(
            label: 'Biaya Pengiriman',
            value: formatCurrency(deliveryFee),
          ),
          const SizedBox(height: 4),
          _FeeRow(label: 'Biaya Layanan', value: formatCurrency(serviceFee)),
          const SizedBox(height: 4),
          _FeeRow(label: 'Pajak (10%)', value: formatCurrency(tax)),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 4),
          _FeeRow(label: 'Total', value: formatCurrency(total), isBold: true),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _FeeRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? const Color(0xFF635BFF) : Colors.black,
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
        children: [
          _BottomNavItem(
            icon: Icons.home,
            label: "Home",
            isActive: currentIndex == 0,
          ),
          _BottomNavItem(
            icon: Icons.receipt_long,
            label: "Riwayat",
            isActive: currentIndex == 1,
          ),
          _BottomNavItem(
            icon: Icons.person,
            label: "Profil",
            isActive: currentIndex == 2,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
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
