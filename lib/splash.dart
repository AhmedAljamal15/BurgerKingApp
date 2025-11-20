import 'package:fast_food/core/constants/app_colors.dart';
import 'package:fast_food/features/auth/data/auth_repo.dart';
import 'package:fast_food/features/auth/views/login_view.dart';
import 'package:fast_food/root.dart';
import 'package:flutter/material.dart';
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

  // AuthRepo authRepo = AuthRepo();
  // Future <void> _checkLogin () async {
  //   try {
  //     final user = await authRepo.autoLogin();
  //     if (!mounted) return;

  //     if(authRepo.isGuest) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Root()));
  //     } else if (authRepo.isLoggedIn) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Root()));
  //     } else {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginView()));
  //     }
  //   } catch (e) {
  //     debugPrint('Auto login failed: $e');
  //     if (mounted) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
  //     }
  //   }
  // }

  AuthRepo authRepo = AuthRepo();

  Future<void> _checkLogin() async {
    try {
      await authRepo.autoLogin();
      if (!mounted) return;

      // If user is logged in (has valid account credentials)
      if (authRepo.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      }
      // If user selected guest mode
      else if (authRepo.isGuest) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      }
      // No login and no guest - go to login screen
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => LoginView()),
        );
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () => setState(() => _opacity = 1.0),
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
