import 'package:fast_food/features/auth/views/login_view.dart';
import 'package:fast_food/features/cart/data/cart_repo.dart';
import 'package:fast_food/shared/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_error.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../../checkout/views/checkout_view.dart';
import '../data/cart_model.dart';
import '../widgets/cart_item.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // final int itemCount = 9;
  List<int> quantities = [];

  CartRepo cartRepo = CartRepo();

  GetCartResponse? getCartRes;

  bool isLoading = false;

  bool isLoadingRemove = false;

  bool isGuest = false;
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    if (mounted) return;
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }

  Future<void> getCart() async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await cartRepo.getCart();
      final itemCount = res.cartData.items.length;
      setState(() {
        getCartRes = res;
        quantities = List.generate(itemCount, (_) => 1);
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Successfully fetched cart")));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      final errorMessage = e is ApiError ? e.message : "Failed to fetch cart";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  //  Delete Cart

  Future<void> removeCartItem(int id) async {
    try {
      setState(() {
        isLoadingRemove = true;
      });
      await cartRepo.removeCartItem(id);
      getCart();
      setState(() {
        isLoadingRemove = false;
      });
    } catch (e) {
      setState(() {
        isLoadingRemove = false;
      });
      customSnack("Failed to remove item from cart");
    }
  }

  @override
  void initState() {
    getCart();
    autoLogin();
    super.initState();
  }

  void onAdd(int index) {
    if (index < quantities.length) {
      setState(() {
        quantities[index]++;
      });
    }
  }

  void onMin(int index) {
    if (index < quantities.length && quantities[index] > 1) {
      setState(() {
        quantities[index]--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox.shrink(),
        centerTitle: true,
        title: CustomText(
          text: 'My Cart',
          color: Colors.black87,
          weight: FontWeight.w600,
          size: 20,
        ),
      ),
      body: isLoading || isGuest || getCartRes == null || quantities.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isGuest
                      ? CustomButton(
                          text: 'Login to checkout',
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                            );
                          },
                        )
                      : isLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.lightGreen,
                          ),
                        )
                      : const Center(child: Text('No items in cart')),
                ],
              ),
            )
          : Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.only(bottom: 140, top: 10),
                    itemCount: getCartRes?.cartData.items.length,
                    physics: const BouncingScrollPhysics(),

                    itemBuilder: (context, index) {
                      final item = getCartRes?.cartData.items[index];

                      // if (item == null) {
                      //   return CupertinoActivityIndicator(
                      //     color: AppColors.primary,
                      //   );
                      // }

                      // Ensure quantities list is properly sized
                      if (index >= quantities.length) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: const Offset(3, 3),
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: CartItem(
                            isLoading: isLoadingRemove,
                            image: item?.img ?? '',
                            text: item?.name ?? '',
                            desc: item?.name ?? '',
                            number: quantities[index],
                            onAdd: () => onAdd(index),
                            onMin: () => onMin(index),
                            onRemove: () {
                              removeCartItem(item?.itemId ?? 1);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Floating total bar
                Positioned(
                  right: -10,
                  left: -10,
                  bottom: -20,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.primary.withOpacity(0.8),
                          AppColors.primary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.9),
                      //     blurRadius: 3,
                      //     offset: const Offset(2, 3),
                      //   ),
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.9),
                      //     blurRadius: 800,
                      //     offset: const Offset(300, 50),
                      //   ),
                      // ],
                    ),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Gap(8),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutView(
                                totalPricel:
                                    getCartRes?.cartData.totalPrice ?? "0.0",
                              ),
                            ),
                          ),
                          child: CustomButton(
                            height: 45,
                            text: 'Checkout',
                            gap: 80,
                            widget: CustomText(
                              text:
                                  '${getCartRes?.cartData.totalPrice ?? "0.0"}\$',
                              size: 14,
                            ),
                            color: Colors.white,
                            width: double.infinity,
                            textColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
