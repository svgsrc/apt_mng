import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:talya_flutter/Modules/Service/qr-scanner-service.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Page/home-page.dart';


class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRScannerController qrScannerController;
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    qrScannerController = QRScannerController();
  }

  @override
  void dispose() {
    qrScannerController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        width: double.infinity,
        margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: QRView(
                key: qrKey,
                onQRViewCreated: (controller) => qrScannerController.onQRViewCreated(controller, context),
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
                          return Container(
                            decoration: BoxDecoration(
                              color:primary,
                              border: Border.all(color: primary, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                qrScannerController.togglePause();
                              },
                              icon: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                color: Colors.white,
                                size: 30,
                              ),
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
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: primary, width: 1),
                              color: primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                qrScannerController.toggleFlash();
                              },
                              icon: Icon(
                                isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
                        controller: codeController,
                        decoration: InputDecoration(
                          hintText: 'Enter the code here',
                          border: border,
                          enabledBorder: enableBorder,
                          focusedBorder: focusBorder
                        ),
                        cursorColor: primary,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primary, width: 1),
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if (codeController.text.isNotEmpty) {
                          await qrScannerController.saveCode(codeController.text);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              blockName: '',
                              hotelId: 0,
                            ),
                          ),
                        );
                      },
                      icon:const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
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
}







