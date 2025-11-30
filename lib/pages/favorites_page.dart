import 'package:flutter/material.dart';
import 'home_page.dart';
import 'food_detail_page.dart';
import '../services/api_services.dart';

class FavoritePage extends StatefulWidget {
  final String username;
  final String phoneNumber;

  const FavoritePage({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> favoriteList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = await ApiService.getFavorites(widget.phoneNumber);
      setState(() {
        favoriteList = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading favorites: $e')),
        );
      }
    }
  }

  Future<void> _removeFromFavorites(int itemId, String itemName) async {
    try {
      await ApiService.removeFromFavorites(widget.phoneNumber, itemId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$itemName dihapus dari favorit'),
          duration: const Duration(seconds: 1),
        ),
      );

      _loadFavorites();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // BACK BUTTON & HEADER
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(
                            username: widget.username,
                            phoneNumber: widget.phoneNumber,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF635BFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Favorit Anda",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // LIST / EMPTY VIEW
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : favoriteList.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada makanan favorit",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          itemCount: favoriteList.length,
                          itemBuilder: (context, index) {
                            final item = favoriteList[index];
                            final itemId = item['id'];
                            final itemName =
                                item['item_name'] ?? 'Unknown';
                            final price = item['price'] ?? '0';
                            final tenantName =
                                item['tenant_name'] ?? 'Unknown';
                            final previewImage =
                                item['preview_image'];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FoodDetailPage(
                                      itemId: itemId,
                                    ),
                                  ),
                                ).then((_) => _loadFavorites());
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 16),
                                padding:
                                    const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFF5F5F5),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(
                                              left: 5),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFFE0E0E0),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      12),
                                          image: previewImage !=
                                                  null
                                              ? DecorationImage(
                                                  image:
                                                      NetworkImage(
                                                          previewImage),
                                                  fit: BoxFit
                                                      .cover,
                                                )
                                              : null,
                                        ),
                                        child: previewImage ==
                                                null
                                            ? const Icon(
                                                Icons
                                                    .restaurant,
                                                color: Colors
                                                    .grey,
                                                size: 30,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            itemName,
                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                          ),
                                          const SizedBox(
                                              height: 2),
                                          Text(
                                            tenantName,
                                            style:
                                                const TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Colors
                                                      .grey,
                                            ),
                                          ),
                                          Text(
                                            'Rp $price',
                                            style:
                                                const TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Color(
                                                      0xFF635BFF),
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(
                                              right: 5),
                                      child:
                                          GestureDetector(
                                        onTap: () {
                                          _removeFromFavorites(
                                              itemId,
                                              itemName);
                                        },
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
