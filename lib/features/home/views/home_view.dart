import 'dart:ui';
import 'package:fast_food/features/home/cubit/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/utils/validators.dart';
import '../../productDetail/views/product_details_view.dart';
import '../widgets/card_item.dart';
import '../widgets/search_field.dart';
import '../widgets/user_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final products = state is HomeLoaded ? state.products : null;
        final userName =
            state is HomeLoaded ? (state.user?.name ?? 'Guest') : 'Guest';
        final userImage = state is HomeLoaded
            ? (state.user?.image ??
                'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png')
            : 'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png';

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Skeletonizer(
            enabled: products == null,
            child: PopScope(
              onPopInvokedWithResult: (didPop, result) =>
                  onWillPop(context),
              child: Scaffold(
                body: CustomScrollView(
                  clipBehavior: Clip.none,
                  slivers: [
                    /// Glassmorphic header
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
                          filter:
                              ImageFilter.blur(sigmaX: 20, sigmaY: 500),
                          child: Container(
                            color: Colors.white
                                .withAlpha(450)
                                .withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 70,
                                right: 20,
                                left: 20,
                              ),
                              child: Column(
                                children: [
                                  UserHeader(
                                    name: userName,
                                    image: userImage,
                                  ),
                                  const Gap(20),
                                  SearchField(
                                    onChanged: (value) =>
                                        context
                                            .read<HomeCubit>()
                                            .search(value),
                                    controller: searchController,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Product grid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              return const CupertinoActivityIndicator();
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
      },
    );
  }
}
