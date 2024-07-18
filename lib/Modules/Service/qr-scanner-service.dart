import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerService {
  static void pauseQRView(QRViewController? controller) {
    controller?.pauseCamera();
  }

  static void toggleFlash(QRViewController? controller) {
    controller?.toggleFlash();
  }
}
