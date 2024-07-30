import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/dashboard-screen.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Service/service-locator.dart';
import 'package:talya_flutter/Modules/Page/dashboard-screen.dart';

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



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: DashboardScreen(),
      ),

    );
  }

}
