import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';
import 'package:talya_flutter/Service/api-service-flats.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    APIServiceFlats apiServiceFlats = APIServiceFlats();
    ;
    return const MaterialApp(
      debugShowMaterialGrid: false,
      home: Scaffold(
        backgroundColor: background,
        body: QRScannerPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }


}