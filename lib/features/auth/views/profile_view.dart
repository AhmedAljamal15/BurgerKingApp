import 'dart:io';
import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:fast_food/features/auth/views/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_snack.dart';
import '../../../shared/custom_text.dart';
import '../data/user_model.dart';
import 'package:fast_food/features/auth/widgets/custom_user_txt_field.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();

  /// Local path of the image selected by the user (before upload)
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    // Load profile on enter
    context.read<AuthCubit>().getProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _address.dispose();
    _visa.dispose();
    super.dispose();
  }

  /// Populate text controllers from a loaded UserModel
  void _populateFields(UserModel user) {
    _name.text = user.name;
    _email.text = user.email;
    _address.text = user.address ?? '55 Dubai, UAE';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _populateFields(state.user);
        }
        if (state is AuthProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack('Profile updated successfully'),
          );
          _populateFields(state.user);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(state.message),
          );
        }
        if (state is AuthLoggedOut) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
          );
        }
      },
      builder: (context, state) {
        final isGuest = state is AuthGuest;
        final isLoading = state is AuthLoading;
        final isUpdating = state is AuthProfileUpdating;

        UserModel? userModel;
        if (state is AuthSuccess) userModel = state.user;
        if (state is AuthProfileUpdating) userModel = state.user;
        if (state is AuthProfileUpdateSuccess) userModel = state.user;

        if (isGuest) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text('Guest Mode')),
                const Gap(20),
                CustomButton(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (c) => const LoginView()),
                  ),
                  text: 'Go to Login',
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          displacement: 40,
          color: Colors.white,
          backgroundColor: AppColors.primary,
          onRefresh: () async => context.read<AuthCubit>().getProfile(),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: PopScope(
              canPop: false,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Skeletonizer(
                      enabled: isLoading && userModel == null,
                      containersColor: AppColors.primary.withOpacity(0.3),
                      child: Column(
                        children: [
                          const Gap(40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          /// Profile image
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: Colors.black),
                              color: Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.primary,
                                    ),
                                    color: Colors.grey.shade100,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: selectedImage != null
                                      ? Image.file(
                                          File(selectedImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : (userModel?.image != null &&
                                              userModel!.image!.isNotEmpty)
                                          ? Image.network(
                                              userModel.image!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, err, builder) =>
                                                      const Icon(Icons.person),
                                            )
                                          : const Icon(Icons.person),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final path = await context
                                      .read<AuthCubit>()
                                      .pickImage();
                                  if (path != null && mounted) {
                                    setState(() => selectedImage = path);
                                  }
                                },
                                child: Card(
                                  elevation: 0.0,
                                  color: const Color.fromARGB(255, 6, 78, 13),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CustomText(
                                          text: 'Upload',
                                          weight: FontWeight.w500,
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                        const Gap(10),
                                        const Icon(
                                          CupertinoIcons.camera,
                                          size: 17,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => selectedImage = null);
                                  context
                                      .read<AuthCubit>()
                                      .clearSelectedImage();
                                },
                                child: Card(
                                  elevation: 0.0,
                                  color: const Color.fromARGB(255, 111, 2, 40),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CustomText(
                                          text: 'Remove',
                                          weight: FontWeight.w500,
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                        const Gap(10),
                                        const Icon(
                                          CupertinoIcons.trash,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),

                          /// Form fields
                          CustomUserTxtField(
                            controller: _name,
                            label: 'Name',
                          ),
                          const Gap(25),
                          CustomUserTxtField(
                            controller: _email,
                            label: 'Email',
                          ),
                          const Gap(25),
                          CustomUserTxtField(
                            controller: _address,
                            label: 'Address',
                          ),
                          const Gap(20),
                          const Divider(),
                          const Gap(10),

                          /// VISA card or text field
                          userModel?.visa == null
                              ? CustomUserTxtField(
                                  controller: _visa,
                                  textInputType: TextInputType.number,
                                  label: 'add VISA CARD',
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade900,
                                        Colors.blue.shade900,
                                        Colors.blue.shade500,
                                        Colors.blue.shade900,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/icon/profileVisa.png',
                                        width: 45,
                                        color: Colors.white,
                                      ),
                                      const Gap(20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const CustomText(
                                            text: 'Debit Card',
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          CustomText(
                                            text: userModel?.visa ??
                                                '**** **** **** 9857',
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: CustomText(
                                          text: 'Default',
                                          color: Colors.grey.shade800,
                                          size: 12,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                      const Gap(8),
                                      const Icon(
                                        CupertinoIcons.check_mark_circled_solid,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                          const Gap(5),

                          /// Edit + Logout buttons
                          SizedBox(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.read<AuthCubit>().updateProfile(
                                              name: _name.text.trim(),
                                              email: _email.text.trim(),
                                              address: _address.text.trim(),
                                              imagePath: selectedImage,
                                              visa: _visa.text.trim().isEmpty
                                                  ? null
                                                  : _visa.text.trim(),
                                            ),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: isUpdating
                                          ? const CupertinoActivityIndicator(
                                              color: Colors.white,
                                            )
                                          : const Center(
                                              child: CustomText(
                                                text: 'Edit Profile',
                                                weight: FontWeight.w600,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.read<AuthCubit>().logout(),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.primary,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: 'Logout',
                                          weight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(300),
                        ],
                      ),
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
