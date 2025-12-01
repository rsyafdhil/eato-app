import 'package:flutter/material.dart';
import '../services/api_services.dart';

class OwnerOrderHistoryPage extends StatefulWidget {
  final String username;
  final String phoneNumber;

  const OwnerOrderHistoryPage({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<OwnerOrderHistoryPage> createState() => _OwnerOrderHistoryPageState();
}

class _OwnerOrderHistoryPageState extends State<OwnerOrderHistoryPage> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String _filterStatus = 'all'; // all, dipesan, dimasak, diantarkan

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await ApiService.getToken();

      if (token == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final orders = await ApiService.getUserOrders(token);

      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading orders: $e')));
      }
    }
  }

  List<dynamic> get _filteredOrders {
    if (_filterStatus == 'all') return _orders;
    return _orders.where((order) {
      return order['status_pemesanan'] == _filterStatus;
    }).toList();
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'dipesan':
        return Colors.orange;
      case 'dimasak':
        return Colors.blue;
      case 'diantarkan':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    if (status == null) return 'Dipesan';
    switch (status.toLowerCase()) {
      case 'dipesan':
        return 'Dipesan';
      case 'dimasak':
        return 'Dimasak';
      case 'diantarkan':
        return 'Diantarkan';
      default:
        return status;
    }
  }

  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await ApiService.updateStatusPemesanan(orderId, newStatus);

      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );

      // Reload orders
      _loadOrders();
    } catch (e) {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showStatusDialog(int orderId, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status Pemesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusOption(
              label: 'Dipesan',
              isSelected: currentStatus == 'dipesan',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                if (currentStatus != 'dipesan') {
                  _updateOrderStatus(orderId, 'dipesan');
                }
              },
            ),
            const SizedBox(height: 8),
            _StatusOption(
              label: 'Dimasak',
              isSelected: currentStatus == 'dimasak',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                if (currentStatus != 'dimasak') {
                  _updateOrderStatus(orderId, 'dimasak');
                }
              },
            ),
            const SizedBox(height: 8),
            _StatusOption(
              label: 'Diantarkan',
              isSelected: currentStatus == 'diantarkan',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                if (currentStatus != 'diantarkan') {
                  _updateOrderStatus(orderId, 'diantarkan');
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = amount is int
        ? amount.toDouble()
        : (amount as num).toDouble();
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kelola\nPesanan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Semua',
                          isSelected: _filterStatus == 'all',
                          onTap: () => setState(() => _filterStatus = 'all'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Dipesan',
                          isSelected: _filterStatus == 'dipesan',
                          color: Colors.orange,
                          onTap: () =>
                              setState(() => _filterStatus = 'dipesan'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Dimasak',
                          isSelected: _filterStatus == 'dimasak',
                          color: Colors.blue,
                          onTap: () =>
                              setState(() => _filterStatus = 'dimasak'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Diantarkan',
                          isSelected: _filterStatus == 'diantarkan',
                          color: Colors.green,
                          onTap: () =>
                              setState(() => _filterStatus = 'diantarkan'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _filterStatus == 'all'
                                ? 'Belum ada pesanan'
                                : 'Tidak ada pesanan ${_getStatusText(_filterStatus)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = _filteredOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OwnerOrderCard(
                              orderId: order['id'],
                              orderCode: order['order_code'],
                              tanggal: order['created_at'],
                              statusPemesanan:
                                  order['status_pemesanan'] ?? 'dipesan',
                              statusColor: _getStatusColor(
                                order['status_pemesanan'] ?? 'dipesan',
                              ),
                              items: order['items'] as List<dynamic>,
                              itemsCount: order['items_count'],
                              total: _formatCurrency(order['total_amount']),
                              onStatusTap: () {
                                _showStatusDialog(
                                  order['id'],
                                  order['status_pemesanan'] ?? 'dipesan',
                                );
                              },
                              onDetailTap: () {
                                // Navigate to order detail jika perlu
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? const Color(0xFF635BFF);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OwnerOrderCard extends StatelessWidget {
  final int orderId;
  final String orderCode;
  final String tanggal;
  final String statusPemesanan;
  final Color statusColor;
  final List<dynamic> items;
  final int itemsCount;
  final String total;
  final VoidCallback onStatusTap;
  final VoidCallback onDetailTap;

  const _OwnerOrderCard({
    required this.orderId,
    required this.orderCode,
    required this.tanggal,
    required this.statusPemesanan,
    required this.statusColor,
    required this.items,
    required this.itemsCount,
    required this.total,
    required this.onStatusTap,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = items.isNotEmpty ? items[0] : null;

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
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      tanggal,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onStatusTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            Text(
                              statusPemesanan,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.edit, size: 12, color: statusColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.more_vert, size: 18, color: Colors.grey),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem != null
                            ? firstItem['item_name']
                            : 'Order $orderCode',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        orderCode,
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
                            itemsCount > 1
                                ? '$itemsCount items'
                                : '${firstItem?['quantity'] ?? 1}x',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            total,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF635BFF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(color: color, width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
