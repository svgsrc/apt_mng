import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';


class DetailPage extends StatelessWidget{
  final Apartment apartment;

  DetailPage({required this.apartment});

  @override
  Widget build(BuildContext context) {
    int flatNumber = int.parse(apartment.flatNumber);
    String contactName = apartment.contactName;
    String idNo = apartment.idNo;
    String phone = apartment.phone;
    String ownerName = apartment.ownerName;
    String ownerPhone = apartment.ownerPhone;
    String plateNo = apartment.plateNo;
    int numberOfPeople = apartment.numberOfPeople;
    String sdate = apartment.startDate;
    String edate = apartment.endDate;
    double balance = apartment.balance.toDouble();



    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(contactName),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: appText, fontSize: 20),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: appText),
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
                const Icon(Icons.account_circle, color: Colors.black, size:150),
                const SizedBox(width: 16),
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
                      contactName,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      phone,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Text(
                    //  mail,
                    //  style:const TextStyle(
                     //   fontSize: 16,
                      //  fontWeight: FontWeight.bold,
                     // ),
                   // ),
                    if(ownerName!= contactName)
                      Text(
                        ownerName,
                        style:const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    if(ownerName!= contactName)
                      Text(
                        ownerPhone,
                        style:const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      plateNo,
                      style:const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '$numberOfPeople',
                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              'Başlangıç Tarihi: $sdate',
              style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            Text(
              'Bitiş Tarihi: $edate',
              style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'BALANCE: $balance TL',
                  style:const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child:ListTile(
                title: Text(phone, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  contactName
                ),
                onTap: () {
                  _showCustomDialog(context);
                },

              ),
              )


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
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Ödeme Tutarı', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                const Text('Lütfen ödemek istediğiniz tutarı giriniz.'),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Tutar giriniz.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: primary,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.payment , color: Colors.green),
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






