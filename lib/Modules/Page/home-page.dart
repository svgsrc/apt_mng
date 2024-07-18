import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'detail-page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? apartments;

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  Future<void> loadMockData() async {
    try {
      final String response = await rootBundle.loadString('assets/mock_data.json');
      final data = json.decode(response) as Map<String, dynamic>;
      setState(() {
        apartments = List<Map<String, dynamic>>.from(data['apartments']);
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(apartments == null ? 'Loading...' : apartments![0]['apartmentInfo']['apartmentName'] + ' ' + apartments![0]['apartmentInfo']['blockName']),
        centerTitle: true,
        titleTextStyle: TextStyle(color: appText, fontSize: 20),
      ),
      body: apartments == null ? Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: apartments!.length,
        itemBuilder: (context, index) {
          var apartment = apartments![index];
          return ApartmentCard(apartment: apartment);
        },
      ),
    );
  }
}

class ApartmentCard extends StatelessWidget {
  final Map<String, dynamic> apartment;

  ApartmentCard({required this.apartment});

  @override
  Widget build(BuildContext context) {
    var apartmentInfo = apartment['apartmentInfo'] ?? {};
    String residentName = apartmentInfo['residentName'] ?? 'N/A';
    String ownerName = apartmentInfo['ownerName'] ?? 'N/A';
    String plateNumber = apartmentInfo['plateNumber'] ?? 'N/A';
    int numberOfPeople = apartmentInfo['numberOfPeople'] ?? 0;


    return Card(
      color: Colors.grey[300],
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(residentName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (residentName != ownerName)
                    Text(ownerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  if(plateNumber != 'N/A')
                    Text(plateNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.person),
                  SizedBox(width: 4),
                  Text(numberOfPeople.toString(),
                    style:const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(),
                  ),
                );
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      // Call the resident
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.email, color: Colors.blue),
                    onPressed: () {
                      // Send an email to the resident
                    }
                      ),
                  IconButton(
                     icon: const Icon(Icons.message, color: Colors.green),
                    onPressed: () {
                      // Send an SMS to the resident
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


