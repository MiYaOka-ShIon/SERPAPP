import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

class CartItem extends Product {
  int quantity;

  CartItem({
    required super.id,
    required super.name,
    required super.price,
    required this.quantity,
  });
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final String userName = '山田太郎';
  final int userCoins = 5000;

  final List<Product> products = [
    Product(id: 1, name: '商品1', price: 10),
    Product(id: 2, name: '商品2', price: 15),
    Product(id: 3, name: '商品3', price: 20),
    Product(id: 4, name: '商品4', price: 25),
    Product(id: 5, name: '商品5', price: 30),
    Product(id: 6, name: '商品6', price: 35),
    Product(id: 7, name: '商品7', price: 40),
    Product(id: 8, name: '商品8', price: 45),
  ];

  final List<CartItem> cart = [];

  void addToCart(Product product) {
    setState(() {
      final index = cart.indexWhere((item) => item.id == product.id);
      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(
          CartItem(
            id: product.id,
            name: product.name,
            price: product.price,
            quantity: 1,
          ),
        );
      }
    });
  }

  void updateQuantity(int productId, int change) {
    setState(() {
      cart.removeWhere((item) {
        if (item.id == productId) {
          item.quantity += change;
          return item.quantity <= 0;
        }
        return false;
      });
    });
  }

  int getTotalPrice() {
    return cart.fold(
      0,
      (total, item) => total + item.price * item.quantity,
    );
  }

  int getRemainingCoins() {
    return userCoins - getTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
    body: Column(
      children: [
        // ===== 追加するヘッダー =====
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          child: Row(
            children: [
              const Spacer(),
              Text(
                '$userName：$userCoins コイン',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

    // ===== 既存の画面 =====
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左：商品一覧
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'マーケット',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap: () => addToCart(product),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${product.price}コイン',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16, height: 16),

                // 右：支払い & レジ
                SizedBox(
                  width: isWide ? 320 : double.infinity,
                  child: Column(
                    children: [
                      _card(
                        title: 'レジ',
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 51, 41, 197), // ← ボタン色
                                  foregroundColor: Colors.white, // ← 文字色
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('購入ボタン'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                                '合計', '${getTotalPrice()} コイン'),
                            _infoRow(
                              '決済後の残高',
                              '${getRemainingCoins()} コイン',
                              highlight: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _card(
                        title: 'カート',
                        child: cart.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Center(
                                  child: Text(
                                    '商品が選択されていません',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : Column(
                                children: cart.map((item) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name),
                                        Text(
                                          '${item.price * item.quantity} コイン',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () =>
                                                  updateQuantity(
                                                      item.id, -1),
                                            ),
                                            Text('個数: ${item.quantity}'),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () =>
                                                  updateQuantity(
                                                      item.id, 1),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
      ],
    ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {bool highlight = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: highlight ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
