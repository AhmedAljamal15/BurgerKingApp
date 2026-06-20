import 'package:fast_food/core/theme/theme_cubit.dart';
import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:fast_food/features/cart/cubit/cart_cubit.dart';
import 'package:fast_food/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global ThemeCubit — persists theme across sessions
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        // Global AuthCubit — shared by splash, profile, checkout
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        // Global CartCubit — so cart badge can be updated from anywhere
        BlocProvider<CartCubit>(create: (_) => CartCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Hungry App',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
