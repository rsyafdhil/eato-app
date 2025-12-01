import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/api_services.dart';
import 'dart:async';

class QrPaymentPage extends StatefulWidget {
  final String qrCodeUrl;
  final int orderId;
  final double totalAmount;

  const QrPaymentPage({
    super.key,
    required this.qrCodeUrl,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  State<QrPaymentPage> createState() => _QrPaymentPageState();
}

class _QrPaymentPageState extends State<QrPaymentPage> {
  Timer? _statusCheckTimer;
  bool _isChecking = false;
  String _paymentStatus = 'pending';

  @override
  void initState() {
    super.initState();
    // Auto check status tiap 5 detik
    _startStatusCheck();
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  void _startStatusCheck() {
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    try {
      // Call API untuk cek status order
      final result = await ApiService.getOrderStatus(widget.orderId);

      if (mounted) {
        setState(() {
          _paymentStatus = result['status'] ?? 'pending';
          _isChecking = false;
        });

        // Kalau udah paid, stop timer dan balik ke halaman sebelumnya
        if (_paymentStatus == 'paid') {
          _statusCheckTimer?.cancel();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pembayaran berhasil! ✅'),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context, true); // Return true = sukses
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        backgroundColor: const Color(0xFF635BFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Icon QRIS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 60,
                color: Color(0xFF635BFF),
              ),
            ),

            const SizedBox(height: 24),

            // Total Amount
            const Text(
              'Total Pembayaran',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _formatCurrency(widget.totalAmount),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF635BFF),
              ),
            ),

            const SizedBox(height: 32),

            // QR Code
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: widget.qrCodeUrl,
                version: QrVersions.auto,
                size: 250,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Status Checking Indicator
            if (_isChecking)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF635BFF),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Mengecek status pembayaran...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

            const SizedBox(height: 32),

            // Instruksi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cara Pembayaran:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _InstructionItem(
                    number: '1',
                    text: 'Buka aplikasi e-wallet (GoPay, OVO, Dana, dll)',
                  ),
                  SizedBox(height: 8),
                  _InstructionItem(number: '2', text: 'Pilih menu Scan QR'),
                  SizedBox(height: 8),
                  _InstructionItem(number: '3', text: 'Scan QR code di atas'),
                  SizedBox(height: 8),
                  _InstructionItem(number: '4', text: 'Konfirmasi pembayaran'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Status pembayaran akan otomatis diperbarui',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Selesai
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF635BFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF635BFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF635BFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
        ),
      ],
    );
  }
}
