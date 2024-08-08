import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Service/service-locator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final prefs=await SharedPreferences.getInstance();
  List<String>? savedCodes = prefs.getStringList('saved_codes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {



    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: QRScannerPage(),
      ),

    );
  }

}
