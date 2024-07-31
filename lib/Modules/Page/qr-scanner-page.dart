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
  final TextEditingController _codeController = TextEditingController();
  String responseMessage= '';
  String? blockName;
  int? hotelId;


  @override
  void initState() {
    super.initState();
    qrScannerController = QRScannerController();
  }

  @override
  void dispose() {
    qrScannerController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void updateResponseMessage(String? newMessage){
    if(newMessage != null){
      setState(() {
        responseMessage = newMessage;
      });
    }
  }
  void onQRViewCreated(QRViewController controller) {
    qrScannerController.onQRViewCreated(controller, context);
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        List<String> splitData = scanData.code?.split(',') ?? [];
        if (splitData.length == 2) {
          blockName = splitData[0];
          hotelId = int.tryParse(splitData[1]);
        }
      });
    });
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
                onQRViewCreated:(controller) => qrScannerController.onQRViewCreated(controller, context),
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
                              border: Border.all(color: primary, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                qrScannerController.togglePause();
                              },
                              icon: Icon(
                                isPaused ? Icons.play_arrow : Icons.pause,
                                color: primary,
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                qrScannerController.toggleFlash();
                              },
                              icon: Icon(
                                isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                                color: primary,
                                size: 30,
                              ),
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
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: 'Enter the code here',
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
                        cursorColor: primary,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primary, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if (_codeController.text.isNotEmpty) {
                          await qrScannerController.saveCode(_codeController.text);

                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(blockName: '',hotelId: 0 ,
                            ),
                          ),
                        );


                      },
                      icon: const Icon(
                        Icons.check,
                        color: primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






