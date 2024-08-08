import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Widgets/apartment-card.dart';

class HomePage extends StatefulWidget {
  final String blockName;
  final int hotelId;

  HomePage({Key? key, required this.blockName, required this.hotelId}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: apiService.apartments$.stream,
          builder: (context, snapshot) {
            final apartments = snapshot.data!;
            final titleText = "${apartments.isNotEmpty ? apartments[0].name : ''} - ${widget.blockName} ";

            return Text(
              titleText,
              style: boldTextStyle.copyWith(color: appText, fontSize: 20),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: primary,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: apiService.apartments$.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final apartments = snapshot.data!;

          return ListView.builder(
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              return ApartmentCard(apartment: apartments[index]);
            },
          );
        },
      ),
    );
  }
}
