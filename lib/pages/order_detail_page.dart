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
  Order? orderDetail;
  bool isLoading = true;
  final List<String> _statusList = [
    'dipesan',
    'dimasak',
    'diantarkan',
    'selesai',
    'batal',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.statusPemesanan;
    _checkUserRole();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Ambil data dari API
      final response = await ApiService.getOrderDetail(widget.order.id);

      // ✅ DEBUG: Print response
      print('🔍 Response dari API: $response');
      print('🔍 Alamat dari response: ${response['alamat']}');

      // ✅ PENTING: Parse dari response langsung, BUKAN dari response['data']
      // Karena di ApiService udah return data['data']
      final loadedOrder = Order.fromJson(response);

      // ✅ DEBUG: Print order setelah parsing
      print('🏠 Order alamat setelah parsing: ${loadedOrder.alamat}');

      setState(() {
        orderDetail = loadedOrder;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkUserRole() async {
    final role = await ApiService.getUserRole();
    setState(() {
      _isOwner = role?.toLowerCase() == 'owner';
    });
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final token = await ApiService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final success = await ApiService.updateOrderStatus(
        widget.order.id,
        newStatus,
      );

      if (success) {
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
        return Colors.blue;
      case 'disiapkan':
        return Colors.orange;
      case 'dimasak':
        return Colors.deepOrange;
      case 'diantar':
        return Colors.purple;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'dipesan':
        return Icons.shopping_cart;
      case 'disiapkan':
        return Icons.inventory_2;
      case 'dimasak':
        return Icons.restaurant;
      case 'diantar':
        return Icons.delivery_dining;
      case 'selesai':
        return Icons.check_circle;
      case 'dibatalkan':
        return Icons.cancel;
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
            return RadioListTile<String>(
              title: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: status,
              groupValue: _currentStatus,
              onChanged: (value) {
                Navigator.pop(context);
                if (value != null && value != _currentStatus) {
                  _updateStatus(value);
                }
              },
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

  @override
  Widget build(BuildContext context) {
    final displayOrder = orderDetail ?? widget.order;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.orderCode}'),
        backgroundColor: Colors.deepPurple,
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
                            backgroundColor: Colors.deepPurple,
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

            // Customer Info (hanya untuk owner)
            if (_isOwner) ...[
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
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Informasi Pelanggan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Nama', displayOrder.customerName),
                      _buildInfoRow('Alamat', displayOrder.alamat),
                      if (displayOrder.customerPhone.isNotEmpty)
                        _buildInfoRow(
                          'No. Telepon',
                          displayOrder.customerPhone,
                        ),
                      if (displayOrder.customerEmail.isNotEmpty)
                        _buildInfoRow('Email', displayOrder.customerEmail),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

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
                    _buildInfoRow('Alamat', displayOrder.alamat),
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
                          'Rp ${widget.order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
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
                  '${item.quantity}x @ Rp ${item.price.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${item.subtotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
