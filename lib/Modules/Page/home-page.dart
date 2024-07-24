import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Widgets/apartment-card.dart';
import 'package:talya_flutter/Service/api-service-flats.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<Apartment>> apartmentStream;
  String title='Name and BlockName';

  @override
  void initState() {
    super.initState();
    apartmentStream= APIServiceFlats().fetchApartments();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: StreamBuilder<List<Apartment>>(
          stream: apartmentStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Apartment> apartments = snapshot.data!;
              title = apartments[0].blockName;
            }
            return Text(title);
          },
        ),
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

      body: StreamBuilder<List<Apartment>>(
        stream: apartmentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(
              child: Text(
                'No data found',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          final apartments = snapshot.data!;

          return ListView.builder(
            itemCount: apartments!.length,
            itemBuilder: (context, index) {
              return ApartmentCard(apartment: apartments[index]);
            },
          );
        },
      ),

    );
  }
}


