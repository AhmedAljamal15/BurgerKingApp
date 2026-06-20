import 'package:fast_food/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../widgets/order_details_widget.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.totalPricel});

  final String totalPricel;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  // Pure UI state — acceptable to keep in the view
  String selectedMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    // Read visa from the global AuthCubit — no local AuthRepo needed
    final authState = context.watch<AuthCubit>().state;
    String? visaNumber;
    if (authState is AuthSuccess) visaNumber = authState.user.visa;
    if (authState is AuthProfileUpdateSuccess) {
      visaNumber = authState.user.visa;
    }

    final double subtotal = double.tryParse(widget.totalPricel) ?? 0.0;
    final double total = subtotal + 3.50 + 40.33;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Order summary',
                size: 20,
                weight: FontWeight.w500,
              ),
              const Gap(10),
              OrderDetailsWidget(
                order: widget.totalPricel,
                taxes: '3.50',
                fees: '40.33',
                total: total.toStringAsFixed(2),
              ),
              const Gap(80),
              const CustomText(
                text: 'Payment methods',
                size: 20,
                weight: FontWeight.w500,
              ),
              const Gap(15),

              /// Cash
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: const Color(0xff3C2F2F),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                leading: Image.asset('assets/icon/cash.png', width: 50),
                title: const CustomText(
                  text: 'Cash on Delivery',
                  color: Colors.white,
                ),
                trailing: Radio<String>(
                  activeColor: Colors.white,
                  value: 'Cash',
                  groupValue: selectedMethod,
                  onChanged: (v) => setState(() => selectedMethod = v!),
                ),
                onTap: () => setState(() => selectedMethod = 'Cash'),
              ),
              const Gap(10),

              /// Debit (only shown if user has a visa card)
              if (visaNumber != null)
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: Colors.blue.shade900,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 16,
                  ),
                  leading: const Icon(
                    CupertinoIcons.creditcard,
                    color: Colors.white,
                  ),
                  title: const CustomText(
                    text: 'Debit card',
                    color: Colors.white,
                  ),
                  subtitle: CustomText(
                    text: visaNumber,
                    color: Colors.white,
                  ),
                  trailing: Radio<String>(
                    activeColor: Colors.white,
                    value: 'Visa',
                    groupValue: selectedMethod,
                    onChanged: (v) => setState(() => selectedMethod = v!),
                  ),
                  onTap: () => setState(() => selectedMethod = 'Visa'),
                ),
              const Gap(5),
              Row(
                children: [
                  Checkbox(
                    activeColor: const Color(0xffEF2A39),
                    value: true,
                    onChanged: (v) {},
                  ),
                  const CustomText(
                      text: 'Save card details for future payments'),
                ],
              ),
              const Gap(200),
            ],
          ),
        ),
      ),

      bottomSheet: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade100,
              Colors.teal.shade300,
              Colors.grey.shade400,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.shade800,
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: 'Total', size: 15),
                  CustomText(
                    text: total.toStringAsFixed(2),
                    size: 20,
                  ),
                ],
              ),
              CustomButton(
                text: 'Pay Now',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 200,
                          ),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade800,
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.primary,
                                  child: const Icon(
                                    CupertinoIcons.check_mark,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const Gap(10),
                                CustomText(
                                  text: 'Success!',
                                  weight: FontWeight.bold,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const Gap(3),
                                CustomText(
                                  text:
                                      'Your payment was successful. \nA receipt for this purchase \nhas been sent to your email.',
                                  color: Colors.grey.shade400,
                                  size: 11,
                                ),
                                const Gap(10),
                                CustomButton(
                                  text: 'Close',
                                  width: 200,
                                  onTap: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
