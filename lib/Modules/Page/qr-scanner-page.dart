import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedCode = '';
  bool isFlashOn = false;
  bool isPaused = false;

  final BehaviorSubject<String> scanData$ = BehaviorSubject<String>();
  final BehaviorSubject<bool> flash$ = BehaviorSubject<bool>();
  final BehaviorSubject<bool> pause$ = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();
    scanData$.stream.listen((scanData) {
      setState(() {
        scannedCode = scanData;
      });
    });

    flash$.stream.listen((flashStatus) {
      setState(() {
        isFlashOn = flashStatus;
      });
    });

    pause$.stream.listen((pauseStatus) {
      setState(() {
        isPaused = pauseStatus;
        if (isPaused) {
          controller?.pauseCamera();
        } else {
          controller?.resumeCamera();
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    scanData$.close();
    flash$.close();
    pause$.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        margin: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: primary,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          togglePause();
                        },
                        icon: Icon(
                          isPaused ? Icons.play_arrow : Icons.pause,
                          color: primary,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          toggleFlash();
                        },
                        icon: Icon(
                          isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                          color: primary,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      child: TextFormField(
                        decoration: InputDecoration(

                          hintText: 'Enter the code here',
                          hintStyle: const TextStyle(
                            color: primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.check,
                      color: primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      scanData$.add(scanData.code!);
    });
  }

  void toggleFlash() {
    if (controller != null) {
      controller!.toggleFlash();
      flash$.add(!isFlashOn);
    }
  }

  void togglePause() {
    pause$.add(!isPaused);
  }
}



