import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> apartment;

  const ProfileCard({Key? key, required this.apartment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var apartmentInfo = apartment['apartmentInfo'] ?? {};
    int flatNumber = apartmentInfo['flatNumber'] ?? 0;
    String residentName = apartmentInfo['residentName'] ?? 'N/A';
    String idNo= apartmentInfo['idNo'] ?? 'N/A';
    String residentPhone = apartmentInfo['phone'] ?? 'N/A';
    String ownerName = apartmentInfo['ownerName'] ?? 'N/A';
    String ownerPhone = apartmentInfo['ownerPhone'] ?? 'N/A';
    String plateNumber = apartmentInfo['plateNumber'] ?? 'N/A';
    int numberOfPeople = apartmentInfo['numberOfPeople'] ?? 0;
    String sdate = apartmentInfo['startDate'] ?? 'N/A';
    String edate = apartmentInfo['endDate'] ?? 'N/A';
    double balance = apartmentInfo['balance'] ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(flatNumber.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(residentName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(residentPhone,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(ownerName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(ownerPhone,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(plateNumber,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(numberOfPeople.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Başlangıç Tarihi: $sdate',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Bitiş Tarihi: $edate',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Balance : $balance' ,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

    );
  }
}
