// cart_manager.dart

// ===== CART ITEM MODEL =====
class CartItem {
  final String id;
  final String title;
  final String price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity = 1,
  });
}

// ===== FAVORITE ITEM MODEL =====
class FavoriteItem {
  final String id;
  final String title;
  final String price;
  final DateTime addedAt; 

  FavoriteItem({
    required this.id,
    required this.title,
    required this.price,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}

// ===== CART MANAGER (Singleton) =====
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _cartItems = [];
  final List<FavoriteItem> _favoriteItems = [];

  // CART GETTERS & METHODS
  List<CartItem> get cartItems => _cartItems;

  void addToCart(String id, String title, String price) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(id: id, title: title, price: price));
    }
  }

  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
    }
  }

  int getTotalItems() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void clearCart() {
    _cartItems.clear();
  }

  // FAVORITES GETTERS & METHODS
  List<FavoriteItem> get favoriteItems => _favoriteItems;

  bool isFavorite(String id) {
    return _favoriteItems.any((item) => item.id == id);
  }

  void toggleFavorite(String id, String title, String price) {
    final index = _favoriteItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      // Remove from favorites
      _favoriteItems.removeAt(index);
    } else {
      // Add to favorites
      _favoriteItems.add(
        FavoriteItem(id: id, title: title, price: price),
      );
    }
  }

  void removeFavorite(String id) {
    _favoriteItems.removeWhere((item) => item.id == id);
  }

  void clearFavorites() {
    _favoriteItems.clear();
  }

  int getTotalFavorites() {
    return _favoriteItems.length;
  }
}