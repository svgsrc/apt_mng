import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';


class PaymentDialog extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ödeme Tutarı', style: boldTextStyle,textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Lütfen ödeme tutarını giriniz:',
            style: normalTextStyle,
          ),
          const SizedBox(height:25),
          TextFormField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: border,
              enabledBorder: enableBorder,
              focusedBorder: focusBorder,
              labelText: 'Tutar',
              labelStyle: normalTextStyle.copyWith(color: primary),
            ),
            cursorColor: primary,
          ),
          SizedBox(height: 10),
        ],

      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 225,
              height: 50,
              child:TextButton(
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
                style: TextButton.styleFrom(
                  side: const BorderSide(color: primary, width: 2),
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: radius,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Kaydet', style: normalTextStyle.copyWith(color: Colors.white)),
                    const SizedBox(width: 5),
                    Icon(Icons.payment_rounded, color: appText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
