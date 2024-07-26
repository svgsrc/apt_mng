import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Service/service-locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    APIService apiService = APIService();

    // apiService.fetchApartments().listen((apartments) {
    //   print('Apartments loaded: $apartments');
    // }).onError((error) {
    //   print('Error loading apartments: $error');
    // });


    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: QRScannerPage(),
      ),

    );
  }

}
