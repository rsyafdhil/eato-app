class Order {
  final int id;
  final String orderCode;
  final int userId;
  final String customerName; // ✅ Tambah
  final String customerEmail; // ✅ Tambah
  final String customerPhone; // ✅ Tambah
  final String status;
  final String statusPemesanan;
  final double totalAmount;
  final String createdAt;
  final int itemsCount;
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
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderCode: json['order_code'],
      userId: json['user_id'],
      customerName: json['customer_name'] ?? 'Unknown', // ✅ Tambah
      customerEmail: json['customer_email'] ?? '', // ✅ Tambah
      customerPhone: json['customer_phone'] ?? '', // ✅ Tambah
      status: json['status'],
      statusPemesanan: json['status_pemesanan'] ?? 'dipesan',
      totalAmount: double.parse(json['total_amount'].toString()),
      createdAt: json['created_at'],
      itemsCount: json['items_count'],
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
