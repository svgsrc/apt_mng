import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Widgets/payment-dialog.dart';

class FeesList extends StatelessWidget {
  final List<Fee> fees;

  const FeesList({super.key, required this.fees});

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fees.length,
      itemBuilder: (context, index) {
        final fee = fees[index];
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          fee.feeTypeId == 1
                              ? 'Aylık Ücret'
                              : fee.feeTypeId == 2
                              ? 'Genel Giderler'
                              : fee.feeTypeId == 3
                              ? 'Demirbaş'
                              : 'Diğer',
                          style: boldTextStyle,
                        ),
                        Divider(color: Colors.grey[400]),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            Text(
                              'Ücret Tarihi: ${formatDate(fee.feeDate)}',
                              style: normalTextStyle.copyWith(fontSize: 14),
                            ),
                            Text(
                              ' ${fee.feeAmount} TL',
                              style: normalTextStyle.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        if (fee.paymentDate != null && fee.paymentDate != '')
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              Text(
                                'Ödeme Tarihi: ${formatDate(fee.paymentDate!)}',
                                style: normalTextStyle.copyWith(fontSize: 14),
                              ),
                              Text(
                                ' ${fee.paymentAmount} TL',
                                style: normalTextStyle.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PaymentDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
