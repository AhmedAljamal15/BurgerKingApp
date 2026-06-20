import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:fast_food/features/auth/views/login_view.dart';
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

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
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
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(state.message),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return PopScope(
          canPop: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: glassContainer(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(40),
                        Image.asset(
                          'assets/banner/output-onlinegiftools.gif',
                          height: 180,
                          width: 180,
                        ),

                        Center(
                          child: CustomText(
                            text: 'Welcome to our Food App',
                            color: Colors.white70,
                          ),
                        ),
                        const Gap(20),
                        Column(
                          children: [
                            CustomTxtfield(
                              controller: nameController,
                              hint: 'Name',
                              isPassword: false,
                            ),
                            const Gap(8),
                            CustomTxtfield(
                              controller: emailController,
                              hint: 'Email Address',
                              isPassword: false,
                            ),
                            const Gap(8),
                            CustomTxtfield(
                              controller: passController,
                              hint: 'Password',
                              isPassword: true,
                            ),
                            const Gap(20),

                            /// Sign up button
                            CustomButton(
                              height: 45,
                              gap: 10,
                              widget: isLoading
                                  ? CupertinoActivityIndicator(
                                      color: AppColors.primary,
                                    )
                                  : null,
                              color: Colors.white,
                              textColor: AppColors.primary,
                              text: 'Sign up',
                              onTap: () {
                                if (!formKey.currentState!.validate()) return;
                                context.read<AuthCubit>().signup(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      passController.text.trim(),
                                    );
                              },
                            ),

                            const Gap(20),
                            Row(
                              children: [
                                /// Login
                                Expanded(
                                  child: CustomAuthBtn(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    text: 'Login',
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) => const LoginView(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Gap(15),

                                /// Guest
                                Expanded(
                                  child: CustomAuthBtn(
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    text: 'Guest',
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => const Root(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Gap(290),
                        const CustomText(
                          text: '@RichSonic2025',
                          color: Colors.white,
                          size: 12,
                          weight: FontWeight.bold,
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
