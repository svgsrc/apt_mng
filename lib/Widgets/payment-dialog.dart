import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';


class PaymentDialog extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ödeme Tutarı', style: boldTextStyle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Lütfen ödeme tutarını giriniz:',
            style: normalTextStyle,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: border,
              enabledBorder: enableBorder,
              focusedBorder: focusBorder,
              labelText: 'Tutar',
              labelStyle: normalTextStyle.copyWith(color: Colors.grey[700]),
            ),
            cursorColor: primary,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              'Kaydet', style: normalTextStyle.copyWith(color: primary)),
        ),
        IconButton(
          icon: const Icon(
            Icons.payment_rounded,
            color: Colors.green,
          ),
          onPressed: () {
            final String amountText = amountController.text;
            if (amountText.isNotEmpty) {
              final double? amount = double.tryParse(amountText);
              if (amount != null) {
                Text('Ödenecek Tutar: $amount', style: normalTextStyle);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Geçersiz tutar. Lütfen tekrar deneyin.',
                      style: normalTextStyle,
                    ),
                  ),
                );
              }
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}