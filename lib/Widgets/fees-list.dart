import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Modules/Page/credit-card-form.dart';

class FeesList extends StatelessWidget {
  final List<Fee> fees;

  const FeesList({super.key, required this.fees});

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d/M/yy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Tarih',
                  style: boldTextStyle.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Açıklama',
                  style: boldTextStyle.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Tutar',
                  style: boldTextStyle.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Ödeme',
                  style: boldTextStyle.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: fees.length,
          itemBuilder: (context, index) {
            final fee = fees[index];
            final noPayment = fee.paymentAmount == 0 || fee.paymentAmount == null;
            final isPaymentIncomplete = fee.paymentAmount < fee.feeAmount && fee.paymentAmount != 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Card(
                color: cardColor,
                margin: const EdgeInsets.only(left: 10, right: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: radius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: (isPaymentIncomplete || noPayment) ? red : Colors.black,
                            ),
                            SizedBox(height: 5),
                            Text(
                              formatDate(fee.feeDate),
                              style: normalTextStyle.copyWith(
                                fontSize: 14,
                                color: (isPaymentIncomplete || noPayment) ? red : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          fee.feeTypeId == 1
                              ? 'Aylık Ücret'
                              : fee.feeTypeId == 2
                              ? 'Genel Giderler'
                              : fee.feeTypeId == 3
                              ? 'Demirbaş'
                              : 'Diğer',
                          style: boldTextStyle.copyWith(
                            color: (isPaymentIncomplete || noPayment) ? red : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${fee.feeAmount} TL',
                          style: normalTextStyle.copyWith(
                            fontSize: 14,
                            color: (isPaymentIncomplete || noPayment) ? red : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (fee.paymentDate != null && fee.paymentDate != '')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    fee.paymentAmount.toString(),
                                    style: boldTextStyle.copyWith(
                                      color: (isPaymentIncomplete || noPayment) ? red : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    formatDate(fee.paymentDate!),
                                    style: normalTextStyle.copyWith(
                                      fontSize: 10,
                                      color: (isPaymentIncomplete || noPayment) ? red : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            if (noPayment)
                              Container(
                                decoration: BoxDecoration(
                                  color: green,
                                  borderRadius: radius,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreditCardFormScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(50, 40),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Öde',
                                    style: boldTextStyle.copyWith(
                                      color: appText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
