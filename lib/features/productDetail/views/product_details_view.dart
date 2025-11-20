import 'package:fast_food/core/network/api_error.dart';
import 'package:fast_food/features/cart/data/cart_model.dart';
import 'package:fast_food/features/cart/data/cart_repo.dart';
import 'package:fast_food/features/home/data/models/topping_model.dart';
import 'package:fast_food/features/home/data/repo/product_repo.dart';
import 'package:fast_food/shared/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../widgets/spicy_slider.dart';
import '../widgets/topping_card.dart';

class ProductDetailsView extends StatefulWidget {
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
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double value = 0.5;

  late List<int> selectedTopping = [];
  late List<int> selectedOption = [];

  CartRepo cartRepo = CartRepo();
  List<ToppingModel>? toppings;
  List<ToppingModel>? options;

  ProductRepo productRepo = ProductRepo();
  Future<void> getToppings() async {
    final res = await productRepo.getToppings();
     if (!mounted) return;
    setState(() {
      toppings = res;
    });
  }

  Future<void> getOptions() async {
    final res = await productRepo.getOptions();
     if (!mounted) return;
    setState(() {
      options = res;
    });
  }

  @override
  void initState() {
    getToppings();
    getOptions();
    super.initState();
  }


  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.productImage.isEmpty,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpicySlider(
                  value: value,
                  img: widget.productImage,
                  onChanged: (v) => setState(() => value = v),
                ),

                Gap(40),
                CustomText(text: 'Toppings', size: 18),
                Gap(10),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(toppings?.length ?? 5, (index) {
                      final topping = toppings?[index];
                      if (topping == null) {
                        return CupertinoActivityIndicator();
                      }
                      final isSelected = selectedTopping.contains(topping.id);

                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ToppingCard(
                          color: isSelected
                              ? Colors.green.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1),
                          title: topping.name,
                          imageUrl: topping.image,
                          onAdd: () {
                            setState(() {
                              final id = topping.id;
                              if (isSelected) {
                                selectedTopping.remove(id);
                              } else {
                                selectedTopping.add(id);
                              }
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),

                Gap(25),
                CustomText(text: 'Side Options', size: 18),
                Gap(10),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(options?.length ?? 4, (index) {
                      final option = options?[index];
                      if (option == null) {
                        return CupertinoActivityIndicator();
                      }
                      final isSelected = selectedOption.contains(option.id);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ToppingCard(
                          color: isSelected
                              ? Colors.green.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1),
                          imageUrl: option.image,
                          title: option.name,
                          onAdd: () {
                            setState(() {
                              final id = option.id;
                              if (isSelected) {
                                selectedOption.remove(id);
                              } else {
                                selectedOption.add(id);
                              }
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Gap(200),
              ],
            ),
          ),
        ),

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Burger Price :',
                      size: 15,
                      color: Colors.white,
                    ),
                    CustomText(
                      text: '\$ ${widget.price}',
                      size: 20,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
                CustomButton(
                  widget: isLoading ? CupertinoActivityIndicator() : Icon(CupertinoIcons.cart_badge_plus),
                  gap: 10,
                  height: 48,
                  color: Colors.white,
                  textColor: AppColors.primary,
                  text: 'Add To Cart',
                  onTap: () async {
                    final cartItem = CartModel(
                      productId: widget.productId,
                      quantity: 1,
                      spicy: value,
                      toppings: selectedTopping,
                      sideOptions: selectedOption,
                    );

                    try {
                      setState(() => isLoading = true);
                      await cartRepo.addToCart(
                        CartResponseModel(items: [cartItem]),
                      );
                      setState(() => isLoading = false);  
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnack("Added to cart", color: Colors.green.shade900),
                      );
                    } on ApiError catch (e) {
                      setState(() => isLoading = false);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'Failed to add to cart')),
                      );
                    } on Exception catch (e) {
                      setState(() => isLoading = false);
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
