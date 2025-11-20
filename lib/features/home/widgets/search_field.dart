import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onChanged, this.controller});

  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        ],
        onChanged: onChanged,
        controller: controller,
        cursorHeight: 15,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Search..',
          fillColor: Colors.transparent,
          prefixIcon: Icon(CupertinoIcons.search, size: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
