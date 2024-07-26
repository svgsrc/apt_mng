import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Widgets/apartment-card.dart';

import '../Models/Apartment.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late APIService apiService ;

  @override
  void initState() {
    super.initState();
    apiService = GetIt.I<APIService>();
    apiService.fetchApartments();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Apartmanlar'),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: appText, fontSize: 20),
        leading: Container(),
      ),
        body: StreamBuilder<List<Apartment>?>(
          stream: apiService.apartments$,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
