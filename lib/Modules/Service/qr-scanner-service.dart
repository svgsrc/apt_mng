import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';
import 'package:talya_flutter/Service/api-service.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';

class QRScannerController {
  final pause$ = BehaviorSubject<bool>.seeded(false);
  final flash$ = BehaviorSubject<bool>.seeded(false);
  final blockName$ = BehaviorSubject<String>.seeded('');
  final hotelId$ = BehaviorSubject<int?>.seeded(null);

  QRViewController? qrController;
  final APIService apiService = GetIt.I<APIService>();

  void onQRViewCreated(QRViewController controller, BuildContext context) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) async {
      String qrText = scanData.code ?? '';
      print("QR Text:$qrText");

      List<String> splitData = qrText.split(",");
      if (splitData.length == 2) {
        int? hotelId = int.tryParse(splitData[0]);
        String blockName = splitData[1];
        print('Hotel ID: $hotelId, Block Name: $blockName');


        if (hotelId != null) {
          blockName$.add(blockName);
          hotelId$.add(hotelId);
          await saveCode(qrText);
          await fetchApartmentsAndNavigate(blockName, hotelId , context);
        }
      } else {
        print('QR code format is incorrect: $qrText');
      }
    });
  }

  Future<void> fetchApartmentsAndNavigate(String blockName, int hotelId, BuildContext context) async {
    try {
      List<Apartment> apartments = await apiService.fetchApartments(blockName, hotelId);

      if (apartments.isNotEmpty) {
        navigateToPage(blockName, hotelId, context);
      } else {
        print("No apartments found");
      }
    } catch (e) {
      print("Error fetching apartments: $e");
    }
  }

  void navigateToPage(String blockName, int hotelId, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(blockName: blockName, hotelId: hotelId),
      ),
    );
  }

  Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedCodes = prefs.getStringList('saved_codes') ?? [];
    savedCodes.add(code);
    await prefs.setStringList('saved_codes', savedCodes);
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
    blockName$.close();
    hotelId$.close();
  }
}

