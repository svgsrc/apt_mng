import 'package:flutter/material.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:talya_flutter/Modules/Page/detail-page.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:lottie/lottie.dart';

class WebViewScreen extends StatefulWidget {
  final String htmlContent;
  final Apartment apartment;
  final List<Fee> fees;

  WebViewScreen({
    required this.htmlContent,
    required this.apartment,
    required this.fees,
  });

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController webController;

  void initState() {
    super.initState();

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onUrlChange: (change) {
          if (change.url == 'https://vpos-demo.elektraweb.io/success') {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    apartment: widget.apartment,
                    fees: widget.fees,
                  ),
                ),
              );
            }
          }
        },
        onPageStarted: (String url) {
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (String url) {
          debugPrint('Page finished loading: $url');
        },
        onHttpError: (HttpResponseError error) {
          debugPrint(
              'HTTP Error occurred on page: ${error.response?.statusCode}');

          if (mounted) {
            showFailureDialog();
          }
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('Web Resource Error: ${error.description}');
          if (mounted) {
            showFailureDialog();
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.dataFromString(
        widget.htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
  }

  Future<void> showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/success-animation.json',
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration * 1, () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Text('Ödemeniz başarıyla gerçekleşti',
                    style: normalTextStyle.copyWith(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showFailureDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/failure-animation.json',
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration * 1, () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Ödemeniz gerçekleştirilemedi. Lütfen tekrar deneyin.',
                  style: normalTextStyle.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: Scaffold(
        body: WebViewWidget(
          controller: webController,
        ),
      ),
    );
  }
}
