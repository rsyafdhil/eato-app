class Order {
  final int id;
  final String orderCode;
  final int userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String status;
  final String statusPemesanan;
  final double totalAmount;
  final String createdAt;
  final int itemsCount;
  final String alamat;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.status,
    required this.statusPemesanan,
    required this.totalAmount,
    required this.createdAt,
    required this.itemsCount,
    required this.items,
    required this.alamat,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final List itemList = json['items'] ?? [];
    // ✅ TAMBAH DEBUG PRINT
    print('🔍 DEBUG Order.fromJson:');
    print('   - Raw JSON: $json');
    print('   - alamat dari json: ${json['alamat']}');
    print('   - alamat type: ${json['alamat'].runtimeType}');

    return Order(
      id: json['id'] ?? 0,
      orderCode: json['order_code'] ?? '',
      userId: json['user_id'] ?? 0,
      customerName: json['customer_name'] ?? 'Unknown',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      status: json['status'] ?? '',
      statusPemesanan: json['status_pemesanan'] ?? 'dipesan',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      alamat: json['alamat'] ?? '-',

      // FIX: Jika items_count tidak ada, hitung dari items.length
      itemsCount: json['items_count'] ?? itemList.length,

      // FIX: items selalu diparse aman
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int itemId;
  final String itemName;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['item_id'],
      itemName: json['item_name'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }
}
