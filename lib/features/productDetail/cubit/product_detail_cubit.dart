import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/data/cart_model.dart';
import '../../cart/data/cart_repo.dart';
import '../../home/data/models/topping_model.dart';
import '../../home/data/repo/product_repo.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailInitial());

  final ProductRepo _productRepo = ProductRepo();
  final CartRepo _cartRepo = CartRepo();

  /// Loads toppings and side-options in parallel.
  Future<void> loadData() async {
    emit(ProductDetailLoading());
    try {
      final toppingsFuture = _productRepo.getToppings();
      final optionsFuture = _productRepo.getOptions();
      final toppings = await toppingsFuture;
      final options = await optionsFuture;

      emit(ProductDetailLoaded(toppings: toppings, options: options));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  /// Toggles a topping selection on/off.
  void toggleTopping(int id) {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    final updated = List<int>.from(current.selectedToppings);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(current.copyWith(selectedToppings: updated));
  }

  /// Toggles a side-option selection on/off.
  void toggleOption(int id) {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    final updated = List<int>.from(current.selectedOptions);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(current.copyWith(selectedOptions: updated));
  }

  /// Updates the spicy slider value.
  void setSpicy(double value) {
    final current = state;
    if (current is! ProductDetailLoaded) return;
    emit(current.copyWith(spicyValue: value));
  }

  /// Adds the product to the cart with all current selections.
  Future<void> addToCart({required int productId, required int quantity}) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(current.copyWith(isAddingToCart: true));

    try {
      final cartItem = CartModel(
        productId: productId,
        quantity: quantity,
        spicy: current.spicyValue,
        toppings: current.selectedToppings,
        sideOptions: current.selectedOptions,
      );

      await _cartRepo.addToCart(CartResponseModel(items: [cartItem]));

      final loadedState = current.copyWith(isAddingToCart: false);
      emit(ProductAddedToCart(loadedState));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
