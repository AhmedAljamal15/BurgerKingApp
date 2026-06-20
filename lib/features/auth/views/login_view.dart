import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:fast_food/features/auth/views/signup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../root.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_snack.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/custom_txtfield.dart';
import '../../../shared/glass_container.dart';
import '../widgets/custom_btn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: 'gad@gmail.com');
  final passController = TextEditingController(text: '123456###');

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Root()),
          );
        } else if (state is AuthGuest) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Root()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(state.message),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: glassContainer(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        const Gap(40),

                        Image.asset(
                          'assets/banner/output-onlinegiftools.gif',
                          height: 180,
                          width: 180,
                        ),

                        const CustomText(
                          text: 'Welcome Back',
                          color: Colors.white70,
                          size: 13,
                          weight: FontWeight.w500,
                        ),
                        const Gap(20),
                        Column(
                          children: [
                            CustomTxtfield(
                              controller: emailController,
                              hint: 'Email Address',
                              isPassword: false,
                            ),
                            const Gap(10),
                            CustomTxtfield(
                              controller: passController,
                              hint: 'Password',
                              isPassword: true,
                            ),
                            const Gap(20),
                            CustomButton(
                              height: 45,
                              gap: 10,
                              text: 'Login',
                              color: Colors.white.withOpacity(0.9),
                              textColor: AppColors.primary,
                              widget: isLoading
                                  ? CupertinoActivityIndicator(
                                      color: AppColors.primary,
                                    )
                                  : null,
                              onTap: () {
                                if (!formKey.currentState!.validate()) return;
                                context.read<AuthCubit>().login(
                                      emailController.text.trim(),
                                      passController.text.trim(),
                                    );
                              },
                            ),
                            const Gap(20),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomAuthBtn(
                                    text: 'Signup',
                                    textColor: Colors.white,
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignupView(),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(15),
                                Expanded(
                                  child: CustomAuthBtn(
                                    text: 'Guest',
                                    isIcon: true,
                                    textColor: Colors.white,
                                    onTap: () => context
                                        .read<AuthCubit>()
                                        .continueAsGuest(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 55),
                          child: Center(
                            child: CustomText(
                              size: 12,
                              color: Colors.white,
                              text: '@Ahmed Gad 2025',
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
