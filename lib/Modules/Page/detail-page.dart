import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';
import 'package:talya_flutter/Service/api-service.dart';
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
    fetchData();
  }

  Future<void> fetchData() async {
    await apiService.fetchApartments(
        widget.apartment.blockName, widget.apartment.hotelId);
    final apartments = await apiService.apartments$.first;
    if (apartments != null && apartments.isNotEmpty) {
      await apiService.fetchFees(apartments.first.id, apartments.first.hotelId);
    }
  }

  Future<void> refreshPage() async {
    await fetchData();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

  double getTotalFeeAmount(List<Fee> fees) {
    return fees.fold(0.0, (sum, fee) => sum + (fee.feeAmount ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final apartmentBalance = widget.apartment.balance;
    final blockName = widget.apartment.blockName;
    final hotelId = widget.apartment.hotelId;

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
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              blockName: blockName,
                              hotelId: hotelId,
                            ),
                          ),
                        ),
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
              body: RefreshIndicator(
                onRefresh: refreshPage,
                color: primary,
                backgroundColor: background,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: StreamBuilder(
                    stream: apiService.combinedStream$,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: primary),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.item1 == null ||
                          snapshot.data!.item1!.isEmpty) {
                        return const Center(
                            child: Text('No apartments found.'));
                      } else {
                        Map<int, List<Fee>?> feesMap =
                            snapshot.data!.item2 ?? {};
                        List<Fee> fees = feesMap[widget.apartment.id] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileCard(apartment: widget.apartment),
                            FeesList(fees: fees, apartment: widget.apartment),
                            SizedBox(height: apartmentBalance > 0 ? 80.0 : 0.0),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
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
