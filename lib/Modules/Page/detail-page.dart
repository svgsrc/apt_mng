
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
    return Scaffold(
      appBar:AppBar(
            backgroundColor: primary,
            title: Text(widget.apartment.contactName),
            centerTitle: true,
            titleTextStyle: const TextStyle(
                fontFamily: 'OpenSans', color: appText, fontSize: 20),
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
          }  else if (!snapshot.hasData ||
              snapshot.data!.item1 == null ||
              snapshot.data!.item1!.isEmpty) {
            return const Center(child: Text('No apartments found.'));
          } else {
            Map<int, List<Fee>?> feesMap = snapshot.data!.item2 ?? {};
            List<Fee> fees = feesMap[widget.apartment.id] ?? [];
             return CustomScrollView(
              slivers: [
                // ProfileCard as a SliverToBoxAdapter
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    child: ProfileCard(apartment: widget.apartment),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FeesList(fees: fees),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
