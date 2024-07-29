import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Widgets/apartment-card.dart';


class HomePage extends StatefulWidget {
 final String blockName;
 final int hotelId;

 HomePage({Key? key, required this.blockName,required this.hotelId}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final APIService apiService = GetIt.I<APIService>();
  List<Apartment> apartments = [];


  @override
  void initState() {
    super.initState();
    apiService.fetchApartments(widget.blockName,widget.hotelId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Apartman Daireleri'),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: appText, fontSize: 20),
        leading: Container(),
      ),
        body: StreamBuilder(
          stream: apiService.apartments$.stream,
          builder: (context, snapshot) {
            if (apiService.apartments$.value == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (apiService.apartments$.value!.isEmpty) {
              return const Center(
                child: Text(
                  'Apartman bulunmamaktadır.',
                  style: TextStyle(fontSize: 18),
                ),
              );
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
