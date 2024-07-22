
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScannerController {
  final pause$ = BehaviorSubject<bool>.seeded(false);
  final flash$ = BehaviorSubject<bool>.seeded(false);

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      await saveCode(scanData.code.toString());
    });
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
    pause$.add(!pause$.value);
  }

  void toggleFlash() {
    flash$.add(!flash$.value);
  }

  void dispose() {
    pause$.close();
    flash$.close();
  }
}
