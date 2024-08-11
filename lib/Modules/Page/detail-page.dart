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

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 25,
          backgroundColor: background,
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
                    widget.apartment.contactName,
                    textAlign: TextAlign.center,
                    style: normalTextStyle.copyWith(color: appText, fontSize: 20),
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
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: ProfileCard(apartment: widget.apartment),
                    ),
                    FeesList(fees: fees),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
//title: Text(
//               textAlign: TextAlign.center,
//                 widget.apartment.contactName,
//               style: normalTextStyle.copyWith(color: appText, fontSize: 20)
//             ),
