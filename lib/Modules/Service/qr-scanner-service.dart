import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';

class QRScannerController {
  final BehaviorSubject<String> scanData$ = BehaviorSubject<String>();
  final BehaviorSubject<bool> flash$ = BehaviorSubject<bool>();
  final BehaviorSubject<bool> pause$ = BehaviorSubject<bool>();

  QRViewController? qrViewController;

  QRScannerController() {
    flash$.add(false);
    pause$.add(false);
  }

  void dispose() {
    qrViewController?.dispose();
    scanData$.close();
    flash$.close();
    pause$.close();
  }

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      scanData$.add(scanData.code!);
    });
  }

  void toggleFlash() {
    if (qrViewController != null) {
      qrViewController!.toggleFlash();
      flash$.add(!flash$.value);
    }
  }

  void togglePause() {
    pause$.add(!pause$.value);
    if (pause$.value) {
      qrViewController?.pauseCamera();
    } else {
      qrViewController?.resumeCamera();
    }
  }
}