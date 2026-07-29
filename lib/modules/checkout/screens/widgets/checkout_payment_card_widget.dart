import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/checkout_controller.dart';

/// payment method selection card — COD or online payment via PortPOS
class CheckoutPaymentCardWidget extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutPaymentCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const Divider(height: 20),

            // cash on delivery option
            Obx(
              () => RadioListTile<String>(
                title: const Text('Cash on Delivery (COD)'),
                subtitle: const Text('Pay with cash upon physical delivery.'),
                value: 'COD',
                groupValue: controller.selectedPaymentMethod.value,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  if (val != null) controller.selectedPaymentMethod.value = val;
                },
              ),
            ),

            // online payment via portpos option
            Obx(
              () => RadioListTile<String>(
                title: const Text('Online Payment (bKash / Visa / Mastercard)'),
                subtitle: const Text('Pay securely via PortPOS payment gateway.'),
                value: 'PORTPOS',
                groupValue: controller.selectedPaymentMethod.value,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  if (val != null) controller.selectedPaymentMethod.value = val;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
