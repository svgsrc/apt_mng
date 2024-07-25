import 'package:flutter/material.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talya_flutter/Modules/Page/detail-page.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';



class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    int? flatNumber;
    String contactName = apartment.contactName ?? 'Unknown';
    String ownerName = apartment.ownerName ?? 'Unknown';
    String plateNo = apartment.plateNo ?? 'N/A';
    int numberOfPeople = apartment.numberOfPeople ?? 0;

    try {
      flatNumber = int.parse(apartment.flatNumber ?? '0');
    } catch (e) {
      flatNumber = 0;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Card(
            color: Colors.grey[300],
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (contactName != ownerName)
                          Text(
                            ownerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        if (plateNo != 'N/A')
                          Text(
                            plateNo,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 4),
                        Text(
                          numberOfPeople.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final apiService=APIService();
                      final apartmentId=apartment.id;
                      
                      try{
                        final fees= await apiService.fetchFees(apartmentId).first;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              apartment: apartment,
                              fees: fees,
                            ),
                          ),
                        );
                      }catch(e){
                        print('Failed to load fees: $e');
                      }
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () {
                            _makePhoneCall(apartment.phone);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.email, color: Colors.blue),
                        onPressed: () {
                            // _sendEmail(apartment.email);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.message, color: Colors.green),
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
          ),
        ),
        Positioned(
          left: 10.0,
          top: 5.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Text(
              flatNumber.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
  // Future<void> _sendEmail(String email) async {
  //   final url = 'mailto:$email';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _sendSMS(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
