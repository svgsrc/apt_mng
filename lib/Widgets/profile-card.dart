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
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: cardColor,
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IntrinsicHeight(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    apartment.photoUrl != null && apartment.photoUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(apartment.photoUrl),
                            radius: 40,
                          )
                        : Icon(Icons.account_circle,
                            size: 80, color: Colors.grey[400]),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (apartment.idNo != null &&
                                apartment.idNo.isNotEmpty)
                              Text("KİMLİK NO:", style: boldTextStyle),
                            Text("OTURAN:", style: boldTextStyle),
                            Text("TELEFON:", style: boldTextStyle),
                            if (apartment.contactName.toLowerCase() != apartment.ownerName.toLowerCase())
                              Text("MÜLK SAHİBİ:", style: boldTextStyle),
                            if (apartment.contactName.toLowerCase() != apartment.ownerName.toLowerCase())
                              Text("TELEFON:", style: boldTextStyle),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (apartment.idNo != null &&
                                apartment.idNo.isNotEmpty)
                              Text(apartment.idNo, style: normalTextStyle),
                            Text(apartment.contactName, style: normalTextStyle),
                            Text(apartment.phone, style: normalTextStyle),
                            if (apartment.contactName.toLowerCase() != apartment.ownerName.toLowerCase())
                              Text(apartment.ownerName, style: normalTextStyle),
                            if (apartment.contactName.toLowerCase() != apartment.ownerName.toLowerCase())
                              Text(apartment.ownerPhone,
                                  style: normalTextStyle),
                          ],
                        )
                      ],
                    )
                  ],
                )),
                Divider(color: Colors.grey[400]),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.people, color: Colors.black),
                            const SizedBox(width: 4),
                            Text(apartment.numberOfPeople.toString(),
                                style: normalTextStyle),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey[400],
                        thickness: 1,
                        width: 20,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.car_rental_outlined,
                                color: Colors.black),
                            const SizedBox(width: 4),
                            Text(apartment.plateNo, style: normalTextStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey[400]),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Başlangıç Tarihi",
                                    style: boldTextStyle),
                                Text(formatDate(apartment.startDate),
                                    style: normalTextStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey[400],
                        thickness: 1,
                        width: 20,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Bitiş Tarihi",
                                    style: boldTextStyle),
                                Text(formatDate(apartment.endDate),
                                    style: normalTextStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
          left: 5.0,
          top: 5.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: Row(
              children: [
                Text(
                  apartment.flatNumber.toString(),
                  style: boldTextStyle.copyWith(color: Colors.black),
                ),
                const Icon(Icons.home, color: Colors.black),
              ],
            ),
          )),
    ]);
  }
}
