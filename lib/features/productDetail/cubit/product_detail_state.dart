part of 'product_detail_cubit.dart';

sealed class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final List<ToppingModel> toppings;
  final List<ToppingModel> options;
  final List<int> selectedToppings;
  final List<int> selectedOptions;
  final double spicyValue;
  final bool isAddingToCart;

  ProductDetailLoaded({
    required this.toppings,
    required this.options,
    this.selectedToppings = const [],
    this.selectedOptions = const [],
    this.spicyValue = 0.5,
    this.isAddingToCart = false,
  });

  ProductDetailLoaded copyWith({
    List<ToppingModel>? toppings,
    List<ToppingModel>? options,
    List<int>? selectedToppings,
    List<int>? selectedOptions,
    double? spicyValue,
    bool? isAddingToCart,
  }) {
    return ProductDetailLoaded(
      toppings: toppings ?? this.toppings,
      options: options ?? this.options,
      selectedToppings: selectedToppings ?? this.selectedToppings,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      spicyValue: spicyValue ?? this.spicyValue,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }
}

class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError(this.message);
}

class ProductAddedToCart extends ProductDetailState {
  final ProductDetailLoaded previousState;
  ProductAddedToCart(this.previousState);
}
