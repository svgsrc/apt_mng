import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final Apartment apartment;
  final List<Fee>? fees;
  final APIService apiService = APIService();

  DetailPage({required this.apartment, this.fees});

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

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
    String sdate =formatDate(apartment.startDate) ;
    String edate = formatDate(apartment.endDate);
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
                const Icon(Icons.account_circle, color: Colors.black, size: 150),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flatNumber.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      idNo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children:[
                        Text(
                          contactName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.people, size: 24),
                        const SizedBox(width: 6),
                        Text(
                          '$numberOfPeople',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                      ]
                    ),

                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (ownerName != contactName)
                      Text(
                        ownerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    if (ownerName != contactName)
                      Text(
                        ownerPhone,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    if(plateNo != null && plateNo != 'N/A')
                    Text(
                      plateNo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Başlangıç Tarihi: $sdate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Bitiş Tarihi: $edate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'BALANCE: $balance TL',
                  style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<List<Fee>>(
                stream: fetchFeesForApartment(apartment.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No fees available'));
                  } else {
                    final fees = snapshot.data!;
                    return ListView.builder(
                      itemCount: fees.length,
                      itemBuilder: (context, index) {
                        final fee = fees[index];
                        return ListTile(
                          title: Text(
                            fee.feeTypeId.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            fee.paymentDate,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          trailing: Text(
                            '${fee.feeAmount} TL',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            _showCustomDialog(context);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Stream<List<Fee>> fetchFeesForApartment(int apartmentId) async* {
    await for (final fees in apiService.fetchFees(apartmentId)) {
      yield fees;
    }
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
                  icon: const Icon(Icons.payment, color: Colors.green),
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






