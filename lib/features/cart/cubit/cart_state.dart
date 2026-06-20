part of 'cart_cubit.dart';

sealed class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final GetCartResponse cartData;
  final List<int> quantities;

  CartLoaded({required this.cartData, required this.quantities});

  CartLoaded copyWith({
    GetCartResponse? cartData,
    List<int>? quantities,
  }) {
    return CartLoaded(
      cartData: cartData ?? this.cartData,
      quantities: quantities ?? this.quantities,
    );
  }
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartEmpty extends CartState {}
