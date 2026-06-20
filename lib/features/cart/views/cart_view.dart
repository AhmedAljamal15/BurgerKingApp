import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:fast_food/features/auth/views/login_view.dart';
import 'package:fast_food/features/cart/cubit/cart_cubit.dart';
import 'package:fast_food/shared/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../../checkout/views/checkout_view.dart';
import '../widgets/cart_item.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(state.message),
          );
        }
      },
      builder: (context, state) {
        final authState = context.watch<AuthCubit>().state;
        final isGuest = authState is AuthGuest;
        final isLoading = state is CartLoading;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 30,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox.shrink(),
            centerTitle: true,
            title: const CustomText(
              text: 'My Cart',
              color: Colors.black87,
              weight: FontWeight.w600,
              size: 20,
            ),
          ),
          body: _buildBody(context, state, isGuest, isLoading),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    CartState state,
    bool isGuest,
    bool isLoading,
  ) {
    if (isGuest) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Login to checkout',
              color: AppColors.primary,
              textColor: Colors.white,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(color: Colors.lightGreen),
      );
    }

    if (state is CartEmpty) {
      return const Center(child: Text('No items in cart'));
    }

    if (state is CartError) {
      return Center(child: Text(state.message));
    }

    if (state is CartLoaded) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.only(bottom: 140, top: 10),
              itemCount: state.cartData.cartData.items.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index >= state.quantities.length) {
                  return const SizedBox.shrink();
                }
                final item = state.cartData.cartData.items[index];
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
                      isLoading: false,
                      image: item.img,
                      text: item.name,
                      desc: item.name,
                      number: state.quantities[index],
                      onAdd: () =>
                          context.read<CartCubit>().incrementQty(index),
                      onMin: () =>
                          context.read<CartCubit>().decrementQty(index),
                      onRemove: () =>
                          context.read<CartCubit>().removeItem(item.itemId),
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating total + checkout bar
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
              ),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  const Gap(8),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutView(
                          totalPricel:
                              state.cartData.cartData.totalPrice,
                        ),
                      ),
                    ),
                    child: CustomButton(
                      height: 45,
                      text: 'Checkout',
                      gap: 80,
                      widget: CustomText(
                        text:
                            '${state.cartData.cartData.totalPrice}\$',
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
      );
    }

    return const SizedBox.shrink();
  }
}
