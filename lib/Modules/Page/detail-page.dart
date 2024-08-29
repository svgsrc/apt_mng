import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Widgets/fees-list.dart';
import 'package:talya_flutter/Widgets/profile-card.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final apartmentBalance = widget.apartment.balance;
    // Map<int, double> totalFees = {};
    // for (var fee in widget.fees) {
    //   totalFees[widget.apartment.id] = (totalFees[widget.apartment.id] ?? 0) + fee.feeAmount;
    // }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                backgroundColor: background,
                toolbarHeight: 25,
                flexibleSpace: Container(
                  color: primary,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        color: appText,
                      ),
                      Expanded(
                        child: Text(
                          widget.apartment.contactName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: boldTextStyle.copyWith(
                              color: appText, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
              body: StreamBuilder(
                stream: apiService.combinedStream$,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: primary),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.item1 == null ||
                      snapshot.data!.item1!.isEmpty) {
                    return const Center(child: Text('No apartments found.'));
                  } else {
                    Map<int, List<Fee>?> feesMap = snapshot.data!.item2 ?? {};
                    List<Fee> fees = feesMap[widget.apartment.id] ?? [];

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileCard(apartment: widget.apartment),
                          FeesList(fees: fees),
                          SizedBox(height: apartmentBalance > 0 ? 80.0 : 0.0),
                          // Adjust for bottom card space if needed
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          // if(apartmentBalance > 0 )
          //   Positioned(
          //     left: 0,
          //     right: 0,
          //     bottom: 40,
          //     child: Container(
          //       color:appText,
          //       padding: const EdgeInsets.all(12.0),
          //       child: Text(
          //         "TOPLAM: ${totalFees} TL",
          //         style: boldTextStyle.copyWith(color: Colors.black),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),
          if (apartmentBalance > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: red,
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "BAKİYE: $apartmentBalance TL BORÇ",
                  style: boldTextStyle.copyWith(color: appText),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// widget.fees.map((fee) => fee.feeAmount).reduce((a, b) => a + b)
