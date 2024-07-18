import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation:0.0,
        ),
      ),
      home: QRScannerPage(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}