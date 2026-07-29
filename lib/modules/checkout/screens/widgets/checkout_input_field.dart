import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

/// reusable labeled input field for checkout billing form
class CheckoutInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool showLabelText;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const CheckoutInputField({
    super.key,
    required this.label,
    required this.controller,
    this.showLabelText = true,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // show the label text above the field when enabled
        if (showLabelText) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            // use label as hint text when label is hidden above
            hintText: !showLabelText ? label : null,
            hintStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          ),
        ),
      ],
    );
  }
}
