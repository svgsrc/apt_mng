import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talya_flutter/Modules/Page/detail-page.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final APIService apiService = GetIt.I<APIService>();

  ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    int? flatNumber;
    String contactName = apartment.contactName ?? 'Unknown';
    String ownerName = apartment.ownerName ?? 'Unknown';
    String plateNo = apartment.plateNo ?? 'N/A';
    int numberOfPeople = apartment.numberOfPeople ?? 0;
    String email=apartment.email??'';
    String photoUrl=apartment.photoUrl??'';

    try {
      flatNumber = int.parse(apartment.flatNumber ?? '0');
    } catch (e) {
      flatNumber = 0;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Card(
            color: cardColor,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: radius,
            ),
            child: InkWell(
              borderRadius: radius,
              onTap: () async {
                final apartmentId = apartment.id;
                try {
                  final fees = await apiService.fetchFees(
                      apartmentId, apartment.hotelId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        apartment: apartment,
                        fees: fees,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Failed to load fees: $e');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              photoUrl != null && photoUrl.isNotEmpty
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(photoUrl),
                                radius: 40,
                              )
                                  :  Icon(Icons.account_circle,
                                  size: 80, color: Colors.grey[400]),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          contactName,
                                          style: boldTextStyle,
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.people,
                                            color: Colors.black),
                                        Text(
                                          numberOfPeople.toString(),
                                          style: boldTextStyle.copyWith(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    if (contactName.toLowerCase() != ownerName.toLowerCase())
                                      Text(ownerName, style: normalTextStyle),
                                    if (plateNo != 'N/A')
                                      Text(plateNo, style: boldTextStyle),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Container(
                                              decoration: const BoxDecoration(
                                                color: green,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(6.0),
                                              child: const Icon(
                                                Icons.phone,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _makePhoneCall(apartment.phone);
                                            },
                                          ),
                                          IconButton(
                                            icon: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(6.0),
                                              child: const Icon(
                                                Icons.email,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _sendEmail(apartment.email);
                                            },
                                          ),
                                          IconButton(
                                            icon: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(6.0),
                                              child: const Icon(
                                                Icons.sms,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              _sendSMS(apartment.phone);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if(apartment.balance!=null && apartment.balance!=0)
                        Text(
                          apartment.balance.toString() + ' TL',
                          style: boldTextStyle.copyWith(color: red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 5.0,
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
                  flatNumber.toString(),
                  style: boldTextStyle.copyWith(color: Colors.black),
                ),
                const Icon(Icons.home, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );

  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
