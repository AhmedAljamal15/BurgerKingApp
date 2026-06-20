import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../data/models/product_model.dart';
import '../data/repo/product_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final ProductRepo _productRepo = ProductRepo();
  final AuthRepo _authRepo = AuthRepo();

  /// Loads products and user profile in parallel.
  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _productRepo.getProducts(),
        _authRepo.getProfileData(),
      ]);

      final products = results[0] as List<ProductModel>;
      final user = results[1] as UserModel?;

      emit(HomeLoaded(
        products: products,
        allProducts: products,
        user: user,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Filters the displayed products by name prefix.
  void search(String query) {
    final current = state;
    if (current is! HomeLoaded) return;

    final filtered = query.isEmpty
        ? current.allProducts
        : current.allProducts
            .where(
              (p) => p.name.toLowerCase().startsWith(query.toLowerCase()),
            )
            .toList();

    emit(current.copyWith(products: filtered));
  }
}
