import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';

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

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRScannerController qrScannerController;

  @override
  void initState() {
    super.initState();
    qrScannerController = QRScannerController();
  }

  @override
  void dispose() {
    qrScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        width: double.infinity,
        margin: const EdgeInsets.only(right: 10, left: 10),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: qrScannerController.onQRViewCreated,
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
                        child: StreamBuilder<bool>(
                          stream: qrScannerController.pause$.stream,
                          builder: (context, snapshot) {
                            bool isPaused = snapshot.data ?? false;
                            return IconButton(
                              onPressed: () {
                                qrScannerController.togglePause();
                              },
                              icon: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                color: primary,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: StreamBuilder<bool>(
                          stream: qrScannerController.flash$.stream,
                          builder: (context, snapshot) {
                            bool isFlashOn = snapshot.data ?? false;
                            return IconButton(
                              onPressed: () {
                                qrScannerController.toggleFlash();
                              },
                              icon: Icon(
                                isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                                color: primary,
                                size: 30,
                              ),
                            );
                          },
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
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: primary,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        }
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
    )
    );
  }
}






