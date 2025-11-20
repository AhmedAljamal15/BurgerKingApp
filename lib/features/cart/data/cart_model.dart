class CartModel {
  final int productId;
  final int quantity;
  final double spicy;
  final List<int> toppings;
  final List<int> sideOptions;

  CartModel({
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': quantity,
    'spicy': spicy,
    'toppings': toppings,
    'side_options': sideOptions,
  };
}

class CartResponseModel {
  final List<CartModel> items;

  CartResponseModel({required this.items});

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
  };
}





class GetCartResponse {
  final int code;
  final String message;
  final CartData cartData;

  GetCartResponse({
    required this.code,
    required this.message,
    required this.cartData,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
      code: json['code'],
      message: json['message'],
      cartData: CartData.fromJson(json['data']),
    );
  }
}

class CartData {
  final int id;
  final String totalPrice;
  final List <CartItemModel> items;

  CartData({required this.id, required this.totalPrice, required this.items});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      totalPrice: json['total_price'],
      items: (json["items"] as List).map((e) => CartItemModel.fromJson(e)).toList(),
    );
  }
}

class CartItemModel {
  final int itemId;
   final String name;
   final String img;
  final int productId;
  final int quantity;
  final double spicy;
  final String price;

  CartItemModel({
    required this.itemId,
    required this.name,
    required this.img,
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json['item_id'] ?? 0,
      name: json['name'],
      img: json['image'],
      productId: json['product_id'],
      quantity: json['quantity'],
      spicy:double.tryParse(json['spicy'].toString()) ?? 0.0,
      price: json['price'].toString(),
    );
  }
}
