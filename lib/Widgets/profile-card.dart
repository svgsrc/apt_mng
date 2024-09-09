import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:clipboard/clipboard.dart';

class ProfileCard extends StatelessWidget {
  final Apartment apartment;

  const ProfileCard({super.key, required this.apartment});

  String formatDate(String date) {
    initializeDateFormatting('tr_TR', null);
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy', 'tr_TR').format(parsedDate);
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (apartment.idNo != null &&
                                      apartment.idNo.isNotEmpty)
                                    const Text("KİMLİK NO:", style: boldTextStyle),
                                  const Text("OTURAN:", style: boldTextStyle),
                                  const Text("TELEFON:", style: boldTextStyle),
                                  if (apartment.contactName.toLowerCase() !=
                                      apartment.ownerName.toLowerCase())
                                    const Text("EV SAHİBİ:", style: boldTextStyle),
                                  if (apartment.contactName.toLowerCase() !=
                                      apartment.ownerName.toLowerCase())
                                    const Text("TELEFON:", style: boldTextStyle),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (apartment.idNo != null &&
                                        apartment.idNo.isNotEmpty)
                                      Text(apartment.idNo, style: normalTextStyle, overflow: TextOverflow.ellipsis),
                                    Text(apartment.contactName, style: normalTextStyle, overflow: TextOverflow.ellipsis),
                                    Text(apartment.phone, style: normalTextStyle, overflow: TextOverflow.ellipsis),
                                    if (apartment.contactName.toLowerCase() !=
                                        apartment.ownerName.toLowerCase())
                                      Text(apartment.ownerName, style: normalTextStyle, overflow: TextOverflow.ellipsis),
                                    if (apartment.contactName.toLowerCase() !=
                                        apartment.ownerName.toLowerCase())
                                      Row(
                                        children: [
                                             Text(apartment.ownerPhone,style: normalTextStyle,),
                                          SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {
                                              FlutterClipboard.copy(apartment.ownerPhone);
                                              showDialog(
                                                barrierColor: Colors.transparent,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      insetPadding: const EdgeInsets.all(5),
                                                      backgroundColor: Colors.grey[850],
                                                      content: SizedBox(
                                                          height: 20,
                                                          child: Center(
                                                              child: Text(
                                                                  "Numara kopyalandı!",
                                                                  style: normalTextStyle.copyWith(
                                                                      color:
                                                                      appText)))));
                                                },
                                              );

                                              Future.delayed(const Duration(seconds: 1), () {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: const Icon(Icons.copy,
                                                size: 17, color: Colors.black),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Divider(color: Colors.grey[400]),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
            decoration: const BoxDecoration(
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
