import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Widgets/apartment-card.dart';
import 'package:talya_flutter/Modules/Models/News.dart';

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

  late Future<News> newsFuture;

  @override
  void initState() {
    super.initState();
    apiService.fetchApartments(widget.blockName, widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return PageView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                padding: EdgeInsets.only(top: topPadding),
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: background,
                    toolbarHeight: 25,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
                      color: primary,
                      height: 50,
                      child: Center(
                        child: StreamBuilder(
                          stream: apiService.apartments$.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(
                                  'Loading...',
                                  style: boldTextStyle.copyWith(color: appText),
                                ),
                              );
                            }
                            final apartments = snapshot.data!;
                            final titleText =
                                "${apartments.isNotEmpty ? apartments[0].name.toUpperCase() : ''} - ${widget.blockName.toUpperCase()} ";
                            return Text(
                              textAlign: TextAlign.center,
                              titleText,
                              style: boldTextStyle.copyWith(
                                  color: appText, fontSize: 20),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  body: StreamBuilder(
                    stream: apiService.apartments$.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(color: primary));
                      }
                      final apartments = snapshot.data!;

                      apartments.sort((a, b) {
                        int flatNumberA =
                            int.tryParse(a.flatNumber ?? '0') ?? 0;
                        int flatNumberB =
                            int.tryParse(b.flatNumber ?? '0') ?? 0;
                        return flatNumberA.compareTo(flatNumberB);
                      });

                      return Container(
                          color: background,
                          child: ListView.builder(
                            itemCount: apartments.length,
                            itemBuilder: (context, index) {
                              return ApartmentCard(
                                  apartment: apartments[index]);
                            },
                          ));
                    },
                  ),
                ),
              ),


            ],
          );
        }


  }

