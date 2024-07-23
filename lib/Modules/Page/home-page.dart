import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Widgets/apartment-card.dart';
import '../Models/Contact.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  Future<void> loadMockData() async {
    try {
      final String response = await rootBundle.loadString('assets/mock_data.json');
      final data = json.decode(response);
      if (data != null && data is Map<String, dynamic> && data.containsKey('apartments')) {
        setState(() {
          contacts = (data['apartments'] as List)
              .map((apartment) => Contact.fromJson(apartment['apartmentInfo'] ?? {}))
              .toList();
        });
        print('Data loaded successfully: $contacts');
      } else {
        print('Invalid JSON structure: $data');
      }
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(contacts == null ? 'Loading...' : contacts![0].apartmentInfo.apartmentName + ' ' + contacts![0].apartmentInfo.blockName),
        centerTitle: true,
        titleTextStyle: TextStyle(color: appText, fontSize: 20),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: appText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: contacts == null ? Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: contacts!.length,
        itemBuilder: (context, index) {
          var contact = contacts![index];
          return ApartmentCard(contact: contact);
        },
      ),
    );
  }
}


