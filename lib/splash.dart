import 'package:fast_food/core/constants/app_colors.dart';
import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:fast_food/features/auth/views/login_view.dart';
import 'package:fast_food/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  Future<void> _checkLogin() async {
    // Use the global AuthCubit to determine login state
    await context.read<AuthCubit>().autoLogin();
    if (!mounted) return;

    final authState = context.read<AuthCubit>().state;

    if (authState is AuthSuccess || authState is AuthGuest) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const Root()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const LoginView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (mounted) setState(() => _opacity = 1.0);
      },
    );
    Future.delayed(const Duration(seconds: 1), _checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.9),
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.7),
            AppColors.primary.withOpacity(0.6),
            AppColors.primary.withOpacity(0.5),
            AppColors.primary.withOpacity(0.4),
            AppColors.primary.withOpacity(0.3),
            AppColors.primary.withOpacity(0.2),
            AppColors.primary.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.green.withOpacity(0.1).withAlpha(1),
        body: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _opacity,
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(280),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: SvgPicture.asset('assets/logo/logo.svg'),
                ),

                const Spacer(),

                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 40, end: 0),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.bounceIn,
                  builder: (context, value, child) => Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  ),
                  child: Image.asset(
                    'assets/splash/splash_intro.png',
                    height: 400.h,
                    width: 400.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
