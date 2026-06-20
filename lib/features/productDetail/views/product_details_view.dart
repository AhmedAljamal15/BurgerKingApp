import 'package:fast_food/features/productDetail/cubit/product_detail_cubit.dart';
import 'package:fast_food/shared/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../widgets/spicy_slider.dart';
import '../widgets/topping_card.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.productImage,
    required this.productId,
    required this.price,
  });

  final String productImage;
  final int productId;
  final String price;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailCubit()..loadData(),
      child: _ProductDetailsBody(
        productImage: productImage,
        productId: productId,
        price: price,
      ),
    );
  }
}

class _ProductDetailsBody extends StatelessWidget {
  const _ProductDetailsBody({
    required this.productImage,
    required this.productId,
    required this.price,
  });

  final String productImage;
  final int productId;
  final String price;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listener: (context, state) {
        if (state is ProductAddedToCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack('Added to cart', color: Colors.green.shade900),
          );
        }
        if (state is ProductDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProductDetailLoading;
        final loaded = state is ProductDetailLoaded
            ? state
            : (state is ProductAddedToCart ? state.previousState : null);

        final isAddingToCart = loaded?.isAddingToCart ?? false;

        return Skeletonizer(
          enabled: productImage.isEmpty,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0.0,
              toolbarHeight: 18,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpicySlider(
                      value: loaded?.spicyValue ?? 0.5,
                      img: productImage,
                      onChanged: (v) =>
                          context.read<ProductDetailCubit>().setSpicy(v),
                    ),
                    const Gap(40),

                    /// Toppings
                    const CustomText(text: 'Toppings', size: 18),
                    const Gap(10),
                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: isLoading
                            ? List.generate(
                                5,
                                (_) => const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: CupertinoActivityIndicator(),
                                ),
                              )
                            : List.generate(
                                loaded?.toppings.length ?? 0,
                                (index) {
                                  final topping = loaded!.toppings[index];
                                  final isSelected = loaded.selectedToppings
                                      .contains(topping.id);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(right: 5),
                                    child: ToppingCard(
                                      color: isSelected
                                          ? Colors.green.withOpacity(0.2)
                                          : AppColors.primary
                                              .withOpacity(0.1),
                                      title: topping.name,
                                      imageUrl: topping.image,
                                      onAdd: () => context
                                          .read<ProductDetailCubit>()
                                          .toggleTopping(topping.id),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),

                    const Gap(25),

                    /// Side Options
                    const CustomText(text: 'Side Options', size: 18),
                    const Gap(10),
                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: isLoading
                            ? List.generate(
                                4,
                                (_) => const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: CupertinoActivityIndicator(),
                                ),
                              )
                            : List.generate(
                                loaded?.options.length ?? 0,
                                (index) {
                                  final option = loaded!.options[index];
                                  final isSelected = loaded.selectedOptions
                                      .contains(option.id);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(right: 8),
                                    child: ToppingCard(
                                      color: isSelected
                                          ? Colors.green.withOpacity(0.2)
                                          : AppColors.primary
                                              .withOpacity(0.1),
                                      imageUrl: option.image,
                                      title: option.name,
                                      onAdd: () => context
                                          .read<ProductDetailCubit>()
                                          .toggleOption(option.id),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    const Gap(200),
                  ],
                ),
              ),
            ),

            /// Bottom sheet — price + add to cart
            bottomSheet: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.7),
                    AppColors.primary,
                    AppColors.primary,
                    AppColors.primary,
                    AppColors.primary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Burger Price :',
                          size: 15,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: '\$ $price',
                          size: 20,
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ],
                    ),
                    CustomButton(
                      widget: isAddingToCart
                          ? const CupertinoActivityIndicator()
                          : const Icon(CupertinoIcons.cart_badge_plus),
                      gap: 10,
                      height: 48,
                      color: Colors.white,
                      textColor: AppColors.primary,
                      text: 'Add To Cart',
                      onTap: () => context
                          .read<ProductDetailCubit>()
                          .addToCart(
                            productId: productId,
                            quantity: 1,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
