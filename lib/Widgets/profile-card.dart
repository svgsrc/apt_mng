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
    return  Stack(children: [
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
                if (apartment.idNo != '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "KİMLİK NUMARASI : ",
                        style: boldTextStyle,
                      ),
                      Text(
                        apartment.idNo.toString(),
                        style: boldTextStyle,
                      )
                    ],
                  ),
                if (apartment.idNo != '') Divider(color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "OTURAN :",
                      style: boldTextStyle,
                    ),
                    Text(
                      apartment.contactName,
                      style: boldTextStyle,
                    )
                  ],
                ),
                Divider(color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TELEFON : ",
                      style: boldTextStyle,
                    ),
                    const SizedBox(width: 80),
                    const Icon(Icons.phone),
                    Text(
                      apartment.phone,
                      style: boldTextStyle,
                    )
                  ],
                ),
                Divider(color: Colors.grey[400]),
                if (apartment.contactName != apartment.ownerName &&
                    apartment.ownerName != '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "MÜLK SAHİBİ : ",
                        style: boldTextStyle,
                      ),
                      Text(
                        apartment.ownerName,
                        style: boldTextStyle,
                      )
                    ],
                  ),
                if (apartment.contactName != apartment.ownerName &&
                    apartment.ownerName != '')
                  Divider(color: Colors.grey[400]),
                if (apartment.contactName != apartment.ownerName &&
                    apartment.ownerName != '')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TELEFON : ",
                        style: boldTextStyle,
                      ),
                      const SizedBox(width: 80),
                      const Icon(Icons.phone),
                      Text(
                        apartment.ownerPhone,
                        style: boldTextStyle,
                      )
                    ],
                  ),
                if (apartment.contactName != apartment.ownerName &&
                    apartment.ownerName != '')
                  Divider(color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 8),
                            Text(apartment.numberOfPeople.toString(),
                                style: boldTextStyle),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 0),
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.directions_car),
                            const SizedBox(width: 8),
                            Text(apartment.plateNo, style: boldTextStyle),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Başlangıç Tarihi", style: boldTextStyle),
                        Text(formatDate(apartment.startDate),
                            style: boldTextStyle),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text("Bitiş Tarihi", style: boldTextStyle),
                        Text(formatDate(apartment.endDate),
                            style: boldTextStyle),
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.grey[400]),
                Text("BALANCE : ${apartment.balance} TL", style: boldTextStyle),

              ],
            ),
          ),

        ),
      ),
      Positioned(
          right: 9.0,
          top: 5.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              apartment.flatNumber.toString(),
              style: boldTextStyle,
            ),
          ))
    ]
    );

  }
}
