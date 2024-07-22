import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/detail-page.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';
import 'package:talya_flutter/Modules/Page/qr-scanner-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      home: Scaffold(
        backgroundColor: background,
        body: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}