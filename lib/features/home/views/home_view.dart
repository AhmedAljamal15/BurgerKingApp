import 'dart:ui';
import 'package:fast_food/features/auth/data/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/network/api_error.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/custom_snack.dart';
import '../../auth/data/user_model.dart';
import '../../productDetail/views/product_details_view.dart';
import '../data/models/product_model.dart';
import '../data/repo/product_repo.dart';
import '../widgets/card_item.dart';
import '../widgets/search_field.dart';
import '../widgets/user_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ['All', 'Combo', 'Sliders', 'Classic', 'Hot'];
  int selectedIndex = 0;

  TextEditingController searchController = TextEditingController();

  List<ProductModel>? products;
  List<ProductModel>? allProducts;

  ProductRepo productRepo = ProductRepo();

  Future<void> getProfileData() async {
    try {
      final user = await authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String errorMsg = 'Error in Profile';
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }
  }

  Future<void> getProducts() async {
    final res = await productRepo.getProducts();
    if (!mounted) return;
    setState(() {
      allProducts = res;
      products = res;
    });
  }

  @override
  void initState() {
    getProfileData();
    getProducts();
    super.initState();
  }

  bool isGuest = false;

  UserModel? userModel;

  AuthRepo authRepo = AuthRepo();

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    if (mounted) return;
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Skeletonizer(
        enabled: products == null,
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) => onWillPop(context),
          child: Scaffold(
            body: CustomScrollView(
              clipBehavior: Clip.none,
              slivers: [
                /// header
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  floating: false,
                  toolbarHeight: 180,
                  scrolledUnderElevation: 0,
                  backgroundColor: Colors.teal.withOpacity(0.2),
                  automaticallyImplyLeading: false,
                  flexibleSpace: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 500),
                      child: Container(
                        color: Colors.white.withAlpha(450).withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 70,
                            right: 20,
                            left: 20,
                          ),
                          child: Column(
                            children: [
                              UserHeader(
                                name: userModel?.name ?? 'Guest',
                                image:
                                    userModel?.image ??
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                              Gap(20),
                              SearchField(
                                onChanged: (value) {
                                  final searchValue = value.toLowerCase();
                                  setState(() {
                                    products = allProducts
                                        ?.where(
                                          (p) => p.name
                                              .toLowerCase()
                                              .startsWith(searchValue),
                                        )
                                        .toList();
                                  });
                                },
                                controller: searchController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          
                /// Category
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       top: 20,
                //       left: 15,
                //       right: 15,
                //     ),
                //     child: FoodCategory(
                //       category: category,
                //       selectedIndex: selectedIndex,
                //     ),
                //   ),
                // ),
          
                /// GridView
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: products?.length ?? 6,
                      (context, index) {
                        final product = products?[index];
                        if (product == null) {
                          return CupertinoActivityIndicator();
                        }
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => ProductDetailsView(
                                productImage: product.image,
                                productId: product.id,
                                price: product.price,
                              ),
                            ),
                          ),
                          child: CardItem(
                            text: product.name,
                            image: product.image,
                            desc: product.desc,
                            rate: product.rate,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
