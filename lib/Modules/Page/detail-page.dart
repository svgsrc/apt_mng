import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:get_it/get_it.dart';

class DetailPage extends StatefulWidget {
  final Apartment apartment;
  final List<Fee> fees;

  DetailPage({required this.apartment, required this.fees});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final APIService apiService = GetIt.I<APIService>();

  @override
  void initState() {
    super.initState();
    apiService.fetchApartments(
        widget.apartment.blockName, widget.apartment.hotelId);
    apiService.apartments$.listen((apartments) {
      if (apartments != null && apartments.isNotEmpty) {
        apiService.fetchFees(apartments.first.id, apartments.first.hotelId);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(widget.apartment.contactName),
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
      body: StreamBuilder(
        stream: apiService.combinedStream$,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.item1 == null ||
              snapshot.data!.item1!.isEmpty) {
            return const Center(child: Text('No apartments found.'));
          } else {
            List<Apartment> apartments = snapshot.data!.item1!;
            Map<int, List<Fee>?> feesMap = snapshot.data!.item2 ?? {};
            List<Fee> fees = feesMap[widget.apartment.id] ?? [];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle,
                            color: Colors.black, size: 150),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.apartment.flatNumber.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.apartment.idNo != 'N/A' &&
                                widget.apartment.idNo != null)
                              Text(
                                widget.apartment.idNo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Row(children: [
                              Text(
                                widget.apartment.contactName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.people, size: 24),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.apartment.numberOfPeople}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ]),
                            Text(
                              widget.apartment.phone,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.apartment.ownerName !=
                                widget.apartment.contactName)
                              Text(
                                widget.apartment.ownerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            if (widget.apartment.ownerName !=
                                widget.apartment.contactName)
                              Text(
                                widget.apartment.ownerPhone,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            Text(
                              widget.apartment.plateNo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Başlangıç Tarihi: ${formatDate(widget.apartment.startDate)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Bitiş Tarihi: ${formatDate(widget.apartment.endDate)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'BALANCE: ${widget.apartment.balance} TL',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: fees.length,
                        itemBuilder: (context, index) {
                          final fee = fees[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(fee.feeTypeId.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                              subtitle: Text(formatDate(fee.feeDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  )),
                              trailing: Text(
                                '${fee.feeAmount} TL',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey[300],
                              onTap: () {
                                _showPaymentDialog(context);
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showPaymentDialog(BuildContext context) async {
    final TextEditingController _amountController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ödeme Tutarı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lütfen ödeme tutarını girin:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tutar',
                  hintText: 'Ödeme tutarını girin',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                final String amountText = _amountController.text;
                if (amountText.isNotEmpty) {
                  final double? amount = double.tryParse(amountText);
                  if (amount != null) {
                    print('Ödenecek Tutar: $amount');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Geçersiz tutar. Lütfen tekrar deneyin.')),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Öde'),
            ),
          ],
        );
      },
    );
  }

}
