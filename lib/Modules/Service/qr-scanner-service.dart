import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';

class QRScannerController {
  final pause$ = BehaviorSubject<bool>.seeded(false);
  final flash$ = BehaviorSubject<bool>.seeded(false);
  QRViewController? _controller;

  void onQRViewCreated(QRViewController controller, BuildContext context) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await saveCode(scanData.code.toString());
      await sendPostRequest(scanData.code.toString());
      navigateToPage(scanData.code.toString(),context);
    });
  }

  Future<void> sendPostRequest(String code) async {
    final url= 'https://4001.hoteladvisor.net';

    final Map<String, dynamic> requestBody={
      "Action": "Execute",
      "Objetc": "SP_MOBILE_APARTMENT_FLATS_LIST",
      "Parameters":{
        "BLOCKNAME": "A BLOK",
        "HOELID": 20854
      }
    };

    try {
      final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data: $data");
      } else {
        print("Error: ${response.statusCode}");
      }
    }catch(e){
      print("Error: $e");
    }
  }

  void navigateToPage(String code, BuildContext context) {
    //
    if (code == "home") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      print("object0");
    }
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
    if (_controller != null) {
      if (pause$.value) {
        _controller!.resumeCamera();
      } else {
        _controller!.pauseCamera();
      }
      pause$.add(!pause$.value);
    }
  }

  void toggleFlash() {
    if (_controller != null) {
      _controller!.toggleFlash();
      flash$.add(!flash$.value);
    }
  }

  void dispose() {
    pause$.close();
    flash$.close();
  }
}
