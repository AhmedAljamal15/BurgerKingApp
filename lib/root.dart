import 'package:fast_food/features/cart/views/cart_view.dart';
import 'package:fast_food/features/home/cubit/home_cubit.dart';
import 'package:fast_food/features/orderHistory/views/order_history_view.dart';
import 'package:fast_food/shared/custom_text.dart';
import 'package:fast_food/shared/glass_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/views/profile_view.dart';
import 'features/home/views/home_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with TickerProviderStateMixin {
  late List<Widget> screens;
  int currentScreen = 0;
  late List<AnimationController> iconControllers;

  @override
  void initState() {
    super.initState();

    screens = [
      // HomeCubit is scoped to the home tab
      BlocProvider(
        create: (_) => HomeCubit(),
        child: const HomeView(),
      ),
      const CartView(),
      const OrderHistoryView(),
      const ProfileView(),
    ];

    iconControllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    iconControllers[currentScreen].forward();
  }

  @override
  void dispose() {
    for (var c in iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => currentScreen = index);
    iconControllers[index].forward();
    for (var i = 0; i < iconControllers.length; i++) {
      if (i != index) iconControllers[i].reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: currentScreen,
          children: screens,
        ),
        bottomNavigationBar: GlassBottomNavBar(
          currentIndex: currentScreen,
          onTap: _onTabTapped,
          items: [
            BottomNavItemData(
              label: 'Home',
              icon: const Icon(CupertinoIcons.home),
              filledIcon: AnimatedIcon(
                icon: AnimatedIcons.menu_home,
                progress: iconControllers[0],
              ),
            ),
            BottomNavItemData(
              label: 'Cart',
              icon: const Icon(CupertinoIcons.cart),
              filledIcon: Badge(
                label: const CustomText(text: '1', size: 10),
                child: AnimatedIcon(
                  icon: AnimatedIcons.view_list,
                  progress: iconControllers[0],
                ),
              ),
            ),
            BottomNavItemData(
              label: 'History',
              icon: const Icon(Icons.table_bar_outlined),
              filledIcon: const Icon(Icons.table_bar),
            ),
            BottomNavItemData(
              label: 'Profile',
              icon: const Icon(CupertinoIcons.person_alt_circle),
              filledIcon: AnimatedIcon(
                size: 20,
                icon: AnimatedIcons.arrow_menu,
                progress: iconControllers[0],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
