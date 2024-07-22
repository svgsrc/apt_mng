import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Models/ApartmentInfo.dart';
import 'package:talya_flutter/Modules/Models/Contact.dart';
import 'package:talya_flutter/Global/constants.dart';

class DetailPage extends StatelessWidget{
  final Contact contact;

  DetailPage({required this.contact});

  @override
  Widget build(BuildContext context) {
    var apartmentInfo = contact.apartmentInfo;
    int flatNumber = apartmentInfo.flatNumber;
    String residentName = apartmentInfo.residentName;
    String idNo = apartmentInfo.idNo;
    String residentPhone = apartmentInfo.phone;
    String ownerName = apartmentInfo.ownerName;
    String ownerPhone = apartmentInfo.ownerPhone;
    String plateNumber = apartmentInfo.plateNumber;
    String mail= apartmentInfo.email;
    int numberOfPeople = apartmentInfo.numberOfPeople;
    String sdate = apartmentInfo.startDate;
    String edate = apartmentInfo.endDate;
    double balance = apartmentInfo.balance;




    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(contacts == null ? 'Loading...' :  apartmentInfo.residentName),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: Colors.black, size:150),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       flatNumber.toString(),
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      idNo,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      residentName,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      residentPhone,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      mail,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(ownerName!= residentName)
                    Text(
                      ownerName,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    if(ownerName!= residentName)
                    Text(
                      ownerPhone,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      plateNumber,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.people, size: 24),
                        SizedBox(width: 8),
                        Text(
                          '$numberOfPeople',
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),
            Text(
              'Başlangıç Tarihi: $sdate',
              style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            Text(
              'Bitiş Tarihi: $edate',
              style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'BALANCE: $balance TL',
                  style:const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(),

          ],
        ),
      ),
    );
  }
  Future<void> _showCustomDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Ödeme Tutarı', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                Text('Lütfen ödemek istediğiniz tutarı giriniz.'),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Tutar giriniz.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primary,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.payment , color: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

}






