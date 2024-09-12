import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/news-page.dart';
import 'package:talya_flutter/Service/api-service.dart';

import '../../Widgets/apartment-card.dart';

class HomePage extends StatefulWidget {
  final String blockName;
  final int hotelId;

  HomePage({Key? key, required this.blockName, required this.hotelId})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final APIService apiService = GetIt.I<APIService>();

  @override
  void initState() {
    super.initState();
    apiService.fetchApartments(widget.blockName, widget.hotelId);
  }

  Future<void> refreshData() async {
    await apiService.fetchApartments(widget.blockName, widget.hotelId);
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: apiService.apartments$.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...',
                          style: boldTextStyle.copyWith(
                              color: appText, fontSize: 20));
                    }
                    final apartments = snapshot.data!;
                    final titleText =
                        "${apartments.isNotEmpty ? apartments[0].name.toUpperCase() : ''} - ${widget.blockName.toUpperCase()}";
                    return Text(
                      titleText,
                      textAlign: TextAlign.center,
                      style:
                          boldTextStyle.copyWith(color: appText, fontSize: 20),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const TabBar(
                  dividerColor: primary,
                  labelColor: primary,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      color: appText,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.apartment),
                    ),
                    Tab(
                      icon: Icon(Icons.notifications),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Apartments Tab with RefreshIndicator
              Container(
                color: background,
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  color: primary,
                  backgroundColor: background,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: apiService.apartments$.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: primary));
                            }
                            final apartments = snapshot.data!;

                            apartments.sort((a, b) {
                              int flatNumberA =
                                  int.tryParse(a.flatNumber ?? '0') ?? 0;
                              int flatNumberB =
                                  int.tryParse(b.flatNumber ?? '0') ?? 0;
                              return flatNumberA.compareTo(flatNumberB);
                            });

                            return ListView.builder(
                              itemCount: apartments.length,
                              itemBuilder: (context, index) {
                                return ApartmentCard(
                                    apartment: apartments[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15),
                color: background,
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  color: primary,
                  backgroundColor: background,
                  child: Column(
                    children: [
                      Expanded(
                        child: NewsPage(
                          hotelId: widget.hotelId,
                          startDate: '2024-01-01',
                          endDate: '2025-01-01',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
