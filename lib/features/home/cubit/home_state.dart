part of 'home_cubit.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  final List<ProductModel> allProducts;
  final UserModel? user;

  HomeLoaded({
    required this.products,
    required this.allProducts,
    this.user,
  });

  HomeLoaded copyWith({
    List<ProductModel>? products,
    List<ProductModel>? allProducts,
    UserModel? user,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      user: user ?? this.user,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
