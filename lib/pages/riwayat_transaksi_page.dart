import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'home_page.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  final String username;
  final String phoneNumber;

  const RiwayatTransaksiPage({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final riwayatDummy = [
      {
        "tanggal": "08 Okt 2025",
        "status": "Selesai",
        "productName": "Product name",
        "toko": "Toko",
        "qty": "Qty",
        "total": "Total Price",
      },
      {
        "tanggal": "08 Okt 2025",
        "status": "Selesai",
        "productName": "Product name",
        "toko": "Toko",
        "qty": "Qty",
        "total": "Total Price",
      },
      {
        "tanggal": "08 Okt 2025",
        "status": "Selesai",
        "productName": "Product name",
        "toko": "Toko",
        "qty": "Qty",
        "total": "Total Price",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Riwayat\nTransaksi",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: riwayatDummy.length,
                itemBuilder: (context, index) {
                  final item = riwayatDummy[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RiwayatCard(
                      tanggal: item["tanggal"]!,
                      status: item["status"]!,
                      productName: item["productName"]!,
                      toko: item["toko"]!,
                      qty: item["qty"]!,
                      total: item["total"]!,
                    ),
                  );
                },
              ),
            ),

            _BottomNavBar(
              currentIndex: 1,
              username: username,
              phoneNumber: phoneNumber,
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final String tanggal;
  final String status;
  final String productName;
  final String toko;
  final String qty;
  final String total;

  const _RiwayatCard({
    required this.tanggal,
    required this.status,
    required this.productName,
    required this.toko,
    required this.qty,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
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
                        toko,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            qty,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            total,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
          
          // HOME
          _BottomNavItem(
            icon: Icons.home,
            label: "Home",
            isActive: currentIndex == 0,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    username: username,
                    phoneNumber: phoneNumber,
                  ),
                ),
              );
            },
          ),

          // RIWAYAT
          _BottomNavItem(
            icon: Icons.receipt_long,
            label: "Riwayat",
            isActive: currentIndex == 1,
            onTap: () {},
          ),

          // PROFILE
          _BottomNavItem(
            icon: Icons.person,
            label: "Profil",
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
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
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
