import 'package:flutter/material.dart';

const transparent = Colors.transparent;
const primary = Color(0xFF557571);
const background =Color(0xFFF5F5F5);
const appText = Colors.white;
final cardColor= Colors.white;
const red= Color(0xFFC40018);
const green= Color(0xFF95CD41);
const orange= Color(0xFFFF6500);
const blue=Color(0xFF64CCDA);


double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

const url = 'https://4001.hoteladvisor.net';

final BorderRadius  radius= BorderRadius.circular(10);

const TextStyle boldTextStyle = TextStyle(
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

const TextStyle normalTextStyle = TextStyle(
  fontFamily: 'OpenSans',
  fontSize: 16,
);

final OutlineInputBorder enableBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide:const BorderSide(
    color: primary,
  ),
);

final OutlineInputBorder focusBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide:const  BorderSide(
    color: primary,
  ),
);

final OutlineInputBorder border= OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
);


final myDivider= Divider(color: Colors.grey[400]);

