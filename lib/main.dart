import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/news-page.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Service/service-locator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final prefs=await SharedPreferences.getInstance();
  List<String>? savedCodes = prefs.getStringList('saved_codes');
  runApp(const MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: NewsPage(hotelId: 20854, startDate: '2024-01-01', endDate: '2025-01-01'),

    ),
    );
  }

}
