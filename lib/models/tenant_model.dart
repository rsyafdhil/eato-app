class Tenant {
  final int id;
  final String name;
  final String? description;
  final String? previewImage;
  final int ownerId;
  final int itemsCount;
  final List<Item>? items;

  Tenant({
    required this.id,
    required this.name,
    this.description,
    this.previewImage,
    required this.ownerId,
    required this.itemsCount,
    this.items,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      previewImage: json['preview_image'],
      ownerId: json['owner_id'],
      itemsCount: json['items_count'] ?? 0,
      items: json['items'] != null
          ? (json['items'] as List).map((i) => Item.fromJson(i)).toList()
          : null,
    );
  }
}

class Item {
  final int id;
  final String itemName;
  final String? description;
  final String slug;
  final int price;
  final String? previewImage;
  final Category? category;
  final SubCategory? subCategory;

  Item({
    required this.id,
    required this.itemName,
    this.description,
    required this.slug,
    required this.price,
    this.previewImage,
    this.category,
    this.subCategory,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemName: json['item_name'],
      description: json['description'],
      slug: json['slug'],
      price: json['price'],
      previewImage: json['preview_image'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      subCategory: json['sub_category'] != null ? SubCategory.fromJson(json['sub_category']) : null,
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SubCategory {
  final int id;
  final String name;

  SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}