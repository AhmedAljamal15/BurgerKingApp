import 'package:fast_food/core/network/api_error.dart';
import 'package:fast_food/core/network/api_service.dart';
import 'package:fast_food/features/cart/data/cart_model.dart';

class CartRepo {
  ApiService apiService = ApiService();

  // add to cart
  Future<void> addToCart(CartResponseModel cartResponseModel) async {
    try {
      final res = await apiService.post(
        "/cart/add",
        cartResponseModel.toJson(),
      );
      if (res is ApiError) {
        throw res;
      }
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // get cart
  Future<GetCartResponse> getCart() async {
    try {
      final res = await apiService.get("/cart");
      if (res is ApiError) {
        throw res;
      }
      return GetCartResponse.fromJson(res);
    } catch (e) {
      if (e is ApiError) {
        throw e;
      }
      throw ApiError(message: 'Failed to get cart: ${e.toString()}');
    }
  }

  // Delete Cart
  Future<void> removeCartItem(int id) async {
    try {
      final res = await apiService.delete("/cart/remove/$id", {});
      if (res['code'] == 200 && res['data'] == null) {
        throw ApiError(message: res['message']);
      }
    } catch (e) {
      throw ApiError(message: 'remove item from cart failed ${e.toString()}');
    }
  }






// Save order 
 Future<void> addSaveOrder(CartResponseModel cartResponseModel) async {
    try {
      final res = await apiService.post(
        "/orders",
        cartResponseModel.toJson(),
      );
      if (res is ApiError) {
        throw res;
      }
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

}
