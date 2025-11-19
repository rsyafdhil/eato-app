import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar custom simple
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Tombol back
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
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
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Card produk 1
                    _CheckoutProductCard(),
                    const SizedBox(height: 8),
                    // Card produk 2
                    _CheckoutProductCard(),

                    const SizedBox(height: 16),

                    // Card Tujuan
                    _AlamatCard(),

                    const SizedBox(height: 16),

                    // Card Fee
                    _FeeCard(),

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
                        onPressed: () {},
                        child: const Text(
                          "Bayar",
                          style: TextStyle(
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
            _BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}

class _CheckoutProductCard extends StatelessWidget {
  const _CheckoutProductCard();

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          // Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Product name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF635BFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        "Qty",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlamatCard extends StatelessWidget {
  const _AlamatCard();

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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "Alamat anda",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Dikirim ke :\n{Alamat}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 12),
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
  const _FeeCard();

  @override
  Widget build(BuildContext context) {
    final feeItems = List.generate(6, (_) => "Fee");

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
          for (final fee in feeItems) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fee,
                  style: const TextStyle(fontSize: 13),
                ),
                const Text(
                  "Rp. x",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex; // 0: Home, 1: Riwayat, 2: Profil
  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF2EAFE),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
