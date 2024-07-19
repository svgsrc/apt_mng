import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Models/ApartmentInfo.dart';
import 'package:talya_flutter/Global/constants.dart';

class DetailPage extends StatelessWidget {
  final Contact contact;

  const DetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    var apartmentInfo = contact.apartmentInfo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(apartmentInfo.apartmentName + ' ' + apartmentInfo.blockName),
        centerTitle: true,
        titleTextStyle: TextStyle(color: appText, fontSize: 20),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: appText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.account_circle, color: Colors.black, size: 100),
            Text(apartmentInfo.flatNumber.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(apartmentInfo.residentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(apartmentInfo.phone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(apartmentInfo.ownerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(apartmentInfo.ownerPhone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(apartmentInfo.plateNumber,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(apartmentInfo.numberOfPeople.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Başlangıç Tarihi: ' + apartmentInfo.startDate,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Bitiş Tarihi: ' + apartmentInfo.endDate,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Balance: ' + apartmentInfo.balance.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
