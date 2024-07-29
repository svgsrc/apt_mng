import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Service/api-service.dart';

class QRScannerController {
  final pause$ = BehaviorSubject<bool>.seeded(false);
  final flash$ = BehaviorSubject<bool>.seeded(false);
  QRViewController? qrController;
  APIService apiService = APIService();

  void onQRViewCreated(QRViewController controller, BuildContext context) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) async {
      String qrText=scanData.code ?? '';
      List<String> splitData=qrText.split(",");
      String? blockName=splitData[0];
      int? hotelId=int.tryParse(splitData[1]);
      if(hotelId!=null){
        await saveCode(qrText);
        await sendPostRequest(blockName, hotelId);
        navigateToPage(blockName,hotelId, context);
      }
    });
  }
  Future<void> sendPostRequest(String blockName,int hotelId) async {
    final Map<String, dynamic> requestBody = {
      "Action": "Execute",
      "Objetc": "SP_MOBILE_APARTMENT_FLATS_LIST",
      "Parameters": {
        "BLOCKNAME": blockName,
        "HOTELID": hotelId,
      }
    };

    try {
      final response = await http.post(Uri.parse(url), body: json.encode(requestBody));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("Data: $data");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  void navigateToPage(String blockName,int hotelId, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(blockName: blockName,hotelId: hotelId),
      ),
    );
  }

  Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedCodes = prefs.getStringList('saved_codes') ?? [];
    savedCodes.add(code);
    await prefs.setStringList('saved_codes', savedCodes);
  }

  Future<List<String>> getSavedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('saved_codes') ?? [];
  }

  void togglePause() {
    if (qrController != null) {
      if (pause$.value) {
        qrController!.resumeCamera();
      } else {
        qrController!.pauseCamera();
      }
      pause$.add(!pause$.value);
    }
  }

  void toggleFlash() {
    if (qrController != null) {
      qrController!.toggleFlash();
      flash$.add(!flash$.value);
    }
  }

  void dispose() {
    pause$.close();
    flash$.close();
  }
}
