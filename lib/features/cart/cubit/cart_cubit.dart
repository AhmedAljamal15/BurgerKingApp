import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/cart_model.dart';
import '../data/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartRepo _cartRepo = CartRepo();

  /// Fetches the user's cart from the server.
  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final res = await _cartRepo.getCart();
      final itemCount = res.cartData.items.length;

      if (itemCount == 0) {
        emit(CartEmpty());
        return;
      }

      emit(CartLoaded(
        cartData: res,
        quantities: List.generate(itemCount, (_) => 1),
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Removes an item from the cart by its item ID, then reloads.
  Future<void> removeItem(int itemId) async {
    final current = state;
    if (current is! CartLoaded) return;

    // Optimistically show loading without losing current data
    emit(CartLoading());
    try {
      await _cartRepo.removeCartItem(itemId);
      await loadCart();
    } catch (e) {
      emit(CartError('Failed to remove item: ${e.toString()}'));
    }
  }

  /// Increases quantity at the given index.
  void incrementQty(int index) {
    final current = state;
    if (current is! CartLoaded) return;
    if (index >= current.quantities.length) return;

    final updated = List<int>.from(current.quantities);
    updated[index]++;
    emit(current.copyWith(quantities: updated));
  }

  /// Decreases quantity at the given index (minimum 1).
  void decrementQty(int index) {
    final current = state;
    if (current is! CartLoaded) return;
    if (index >= current.quantities.length) return;
    if (current.quantities[index] <= 1) return;

    final updated = List<int>.from(current.quantities);
    updated[index]--;
    emit(current.copyWith(quantities: updated));
  }
}
