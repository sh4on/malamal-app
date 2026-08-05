import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../cart/controllers/cart_controller.dart';

/// reusable dropdown form field for checkout selection forms
class CheckoutDropdownField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final List<String> items;
  final String? Function(String?)? validator;

  const CheckoutDropdownField({
    super.key,
    required this.label,
    required this.controller,
    required this.items,
    this.validator,
  });

  @override
  State<CheckoutDropdownField> createState() => _CheckoutDropdownFieldState();
}

class _CheckoutDropdownFieldState extends State<CheckoutDropdownField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // initialize selected value if controller has a valid value, otherwise default to null
    if (widget.items.contains(widget.controller.text)) {
      _selectedValue = widget.controller.text;
    } else {
      _selectedValue = null;
    }
  }

  @override
  void didUpdateWidget(covariant CheckoutDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // sync selected value if text controller is updated dynamically from outside
    if (widget.items.contains(widget.controller.text)) {
      _selectedValue = widget.controller.text;
    } else {
      _selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // build the dropdown selector styled identically to text input fields for unified design layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.greyDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          key: ValueKey<String?>(_selectedValue),
          initialValue: _selectedValue,
          isExpanded: true,
          dropdownColor: AppColors.white,
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedValue = value;
              widget.controller.text = value ?? '';
            });
            // trigger recalculation of shipping charge in real time when city changes
            if (Get.isRegistered<CartController>()) {
              Get.find<CartController>().updateShippingCost(value ?? '');
            }
          },
          validator: widget.validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
          ),
        ),
      ],
    );
  }
}
