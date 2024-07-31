import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';


class ProfileCard extends StatelessWidget {
  final Apartment apartment;

  const ProfileCard({super.key, required this.apartment});

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.account_circle_rounded,
                  color: Colors.black, size: 125),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.house_outlined, color: Colors.black),
                      Text(apartment.flatNumber, style: boldTextStyle),
                    ],
                  ),
                  if (apartment.idNo != 'N/A')
                    Text(apartment.idNo, style: boldTextStyle),
                  Row(
                    children: [
                      Text(apartment.contactName, style: boldTextStyle),
                      const SizedBox(width: 10),
                      const Icon(Icons.people, color: Colors.black),
                      Text(apartment.numberOfPeople.toString(),
                          style: boldTextStyle),
                    ],
                  ),
                  Text(apartment.phone, style: boldTextStyle),
                  if (apartment.contactName != apartment.ownerName)
                    Text(apartment.ownerName, style: normalTextStyle),
                  Text(apartment.ownerPhone, style: normalTextStyle),
                  if (apartment.plateNo != 'N/A')
                    Text(apartment.plateNo, style: boldTextStyle),
                ],
              ),
            ]),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                RichText(
                  textAlign: TextAlign.center,
                  text:  TextSpan(
                    style: boldTextStyle.copyWith(color: Colors.black),
                    children:<TextSpan> [
                      const TextSpan(text: 'Başlangıç Tarihi'),
                      const TextSpan(text: '\n'),
                      TextSpan(text: formatDate(apartment.startDate)),

                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text:  TextSpan(
                    style: boldTextStyle.copyWith(color: Colors.black),
                    children:<TextSpan> [
                      const TextSpan(text: 'Bitiş Tarihi'),
                      const TextSpan(text: '\n'),
                      TextSpan(text: formatDate(apartment.endDate)),

                    ],
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('BALANCE: ${apartment.balance} TL', style: boldTextStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
