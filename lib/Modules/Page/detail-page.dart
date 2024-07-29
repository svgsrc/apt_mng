import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:get_it/get_it.dart';

class DetailPage extends StatefulWidget {
  final Apartment apartment;
  final List<Fee>? fees;

  DetailPage({Key? key, required this.apartment, this.fees}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late APIService apiService;
  List<Fee> fees = [];


  @override
  void initState() {
    super.initState();
    apiService = GetIt.I<APIService>();
    _fetchFees();
  }

  Future<void> _fetchFees() async {
    final fetchedFees=await apiService.fetchFees(widget.apartment.id, widget.apartment.hotelId);
    setState(() {
      fees=fetchedFees!;
    });
  }

    String formatDate(String date) {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd.MM.yyyy').format(parsedDate);
    }

    @override
    Widget build(BuildContext context) {
      int flatNumber = int.parse(widget.apartment.flatNumber);
      String contactName = widget.apartment.contactName;
      String idNo = widget.apartment.idNo;
      String phone = widget.apartment.phone;
      String ownerName = widget.apartment.ownerName;
      String ownerPhone = widget.apartment.ownerPhone;
      String plateNo = widget.apartment.plateNo;
      int numberOfPeople = widget.apartment.numberOfPeople;
      String sdate = formatDate(widget.apartment.startDate);
      String edate = formatDate(widget.apartment.endDate);
      double balance = widget.apartment.balance.toDouble();
      List<Fee> fees = widget.fees ?? [];



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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(Icons.account_circle,
                        color: Colors.black, size: 150),
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
                          if(idNo != 'N/A' && idNo!=null)
                          Text(
                            idNo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Row(children: [
                          Text(
                            contactName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.people, size: 24),
                          const SizedBox(width: 6),
                          Text(
                            '$numberOfPeople',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
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
              ),
              const SizedBox(height: 16),
              Text(
                'Başlangıç Tarihi: $sdate',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Bitiş Tarihi: $edate',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'BALANCE: $balance TL',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),

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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.4,
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
