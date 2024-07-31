import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Widgets/payment-dialog.dart';


class FeesList extends StatelessWidget{
  final List<Fee> fees;

  FeesList({super.key, required this.fees});

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }
  
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: fees.length,
      itemBuilder: (context, index) {
        final fee = fees[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                fee.feeTypeId == 1
                    ? 'Aylık Ücret'
                    : fee.feeTypeId == 2
                    ? 'Genel Giderler'
                    : fee.feeTypeId == 3
                    ? 'Demirbaş'
                    : 'Diğer',
                style: boldTextStyle,
              ),
              subtitle: Text(formatDate(fee.feeDate), style: normalTextStyle),
              trailing: Text('${fee.feeAmount} TL', style: boldTextStyle),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => PaymentDialog(),
                );
              },
            ),
          ),
        );
      },
    );
  }

}