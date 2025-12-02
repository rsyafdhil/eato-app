import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import '../models/order.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isOwner = false;
  bool _isUpdating = false;
  late String _currentStatus;
  bool _isLoadingRole = true;

  final List<String> _statusList = ['dipesan', 'dimasak', 'diantarkan'];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.statusPemesanan;
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roleName = prefs.getString('user_role');

      print('>>> User Role: $roleName'); // Debug

      setState(() {
        _isOwner = roleName?.toLowerCase() == 'owner';
        _isLoadingRole = false;
      });

      print('>>> Is Owner: $_isOwner'); // Debug
    } catch (e) {
      print('>>> Error checking role: $e');
      setState(() {
        _isLoadingRole = false;
      });
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await ApiService.updateStatusPemesanan(widget.order.id, newStatus);

      setState(() {
        _currentStatus = newStatus;
        _isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal update status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'dipesan':
        return Icons.shopping_cart;
      case 'dimasak':
        return Icons.restaurant;
      case 'diantarkan':
        return Icons.delivery_dining;
      default:
        return Icons.info;
    }
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Status Pemesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _statusList.map((status) {
            final isSelected = status == _currentStatus;
            final color = _getStatusColor(status);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (!isSelected) {
                    _updateStatus(status);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.1)
                        : Colors.transparent,
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
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected ? color : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
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

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Order #${widget.order.orderCode}'),
        backgroundColor: const Color(0xFF635BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Pembayaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status Pembayaran',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.order.status == 'paid'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.order.status.toUpperCase(),
                            style: TextStyle(
                              color: widget.order.status == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Status Pemesanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status Pemesanan',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Icon(
                              _getStatusIcon(_currentStatus),
                              color: _getStatusColor(_currentStatus),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _currentStatus.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(_currentStatus),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ✅ Dropdown HANYA muncul kalau owner
                    if (_isOwner) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isUpdating ? null : _showStatusDialog,
                          icon: _isUpdating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.edit),
                          label: Text(
                            _isUpdating ? 'Memperbarui...' : 'Ubah Status',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF635BFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Order Info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Kode Order', widget.order.orderCode),
                    _buildInfoRow('Tanggal', widget.order.createdAt),
                    _buildInfoRow(
                      'Total Item',
                      '${widget.order.itemsCount} item',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Items List
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...widget.order.items.map((item) => _buildItemCard(item)),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatCurrency(widget.order.totalAmount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF635BFF),
                          ),
                        ),
                      ],
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildItemCard(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fastfood,
              color: Color(0xFF635BFF),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity}x @ ${_formatCurrency(item.price)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency(item.subtotal),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF635BFF),
            ),
          ),
        ],
      ),
    );
  }
}
