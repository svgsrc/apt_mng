import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';

class PaymentDialog extends StatelessWidget {
  final List<Fee> fees;

  PaymentDialog({Key? key, required this.fees}) : super(key: key);
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ödeme Tutarı',
          style: boldTextStyle, textAlign: TextAlign.center),
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
          const SizedBox(height: 8),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 225,
              height: 50,
              child: TextButton(
                onPressed: () {
                  final String amountText = amountController.text;
                  if (amountText.isNotEmpty) {
                    final double? amount = double.tryParse(amountText);

                    if (amount != null && amount > 0 ) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ödeme sayfasına yönlendiriliyorsunuz,\nlütfen bekleyiniz.',
                                style: boldTextStyle.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin:  EdgeInsets.only(
                            top:MediaQuery.of(context).size.height-400,
                            left: 20,
                            right: 20,
                          ),
                          backgroundColor: Colors.white,
                          duration: Duration(seconds: 3),
                        ),
                      );

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Geçersiz tutar girdiniz.',
                                style: boldTextStyle.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin:  EdgeInsets.only(
                            top:MediaQuery.of(context).size.height-400,
                            left: 20,
                            right: 20,
                          ),
                          backgroundColor: Colors.white,
                          duration: Duration(seconds: 3),
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
                    Text('Kaydet',
                        style: normalTextStyle.copyWith(color: Colors.white)),
                    const SizedBox(width: 5),
                    const Icon(Icons.payment_rounded, color: appText),
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
