import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Modules/Page/webView-page.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';

class CreditCardFormScreen extends StatefulWidget {
  final List<Fee> fees;
  final Apartment apartment;

  CreditCardFormScreen({required this.fees, required this.apartment});

  @override
  _CreditCardFormScreenState createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  String pan = '';
  String expiryMonth = '';
  String expiryYear = '';
  String firstName = '';
  String lastName = '';
  String cvv = '';
  String paymentAmount = '';
  String feeUid = '';
  bool isCvvFocused = false;
  String selectedInstallments = '';
  String currency = '';
  List<String> currencyOptions = [];
  String bank = '';
  List<String> installmentOptions = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  void fetchPaymentDetails() {
    final fetchedFee = widget.fees.firstWhere((fee) => !fee.isCompleted,
        orElse: () => Fee(
              id: 0,
              hotelId: 0,
              flatId: 0,
              feeTypeId: 0,
              feeDate: '',
              feeAmount: 0.0,
              paymentDate: DateTime.now().toString(),
              description: '',
              paymentAmount: 0.0,
              uid: '',
            ));

    setState(() {
      paymentAmount = fetchedFee.paymentAmount != null
          ? fetchedFee.paymentAmount.toStringAsFixed(2)
          : '0.00';
      feeUid = fetchedFee.uid; // Fee UIDID
    });
  }

  String generateHashData() {
    String returnUrl = 'http://localhost:3000/checkResponse';
    String data =
        '$firstName$lastName$pan$expiryMonth$expiryYear$cvv$paymentAmount$currency$bank$returnUrl';
    var bytes = utf8.encode(data);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void sendPaymentData() async {
    final paymentData = {
      "firstName": firstName,
      "lastName": lastName,
      "pan": pan,
      "expiryMonth": expiryMonth,
      "expiryYear": expiryYear,
      "cvv": cvv,
      "amount": paymentAmount.isNotEmpty ? paymentAmount : '0.00',
      "currency": currency,
      "bank": bank,
      "returnUrl": "http://localhost:3000/checkResponse",
      "redirectMode": "frontend",
      "hashData": generateHashData(),
      "selectedInstallments":
          '{"installment":"$selectedInstallments","finalPrice":"$paymentAmount"}',
      "isTest": true,
    };

    try {
      final response = await http.post(
        Uri.parse('https://vpos-demo.elektraweb.io/sendCCInfo'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(paymentData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
                htmlContent: responseData['data'],
            apartment: widget.apartment,
            fees: widget.fees,),
          ),
        ).then((paymentResult) {
          if (responseData == true) {
            print('Ödeme Başarılı');

          } else {
            print('Ödeme Başarısız: ${responseData['error']}');
          }
        });
      } else {
        print(
            'Ödeme işleme başarısız oldu. Durum Kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('Ödeme işleme hatası: $e');
    }
  }

  Future<void> fetchBinDetails(String pan) async {
    String binNumber = pan.substring(0, 6);

    if (!RegExp(r'^\d{6}$').hasMatch(binNumber)) {
      print('Hata: Geçersiz BIN numarası formatı.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://vpos-demo.elektraweb.io/getBankInfoWithBin'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'binNumber': binNumber, 'isTest': true}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Gelen veriler: $data');

        final bankInfo = data['bankInfo'];
        if (bankInfo != null && bankInfo['success'] == true) {
          final bankData = bankInfo['data'];
          final bankConfig = bankData['bankConfig'];
          setState(() {
            bank = bankData['bankName'] ?? '';
            currencyOptions = bankConfig['currency'] != null
                ? List<String>.from(bankConfig['currency'])
                : [];
            installmentOptions = bankConfig['installment'] != null
                ? List<String>.from(
                    bankConfig['installment'].map((item) => item.toString()))
                : [];
            currency = currencyOptions.isNotEmpty ? currencyOptions[0] : '';
          });

        } else {
          print('Bank bilgisi alınamadı veya başarı durumu false döndü.');
        }
      } else {
        final errorData = jsonDecode(response.body);
        print(
            'BIN bilgileri alınamadı. Kod: ${response.statusCode}, Hata: ${errorData['error']}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          toolbarHeight: 30,
          flexibleSpace: Container(
            color: primary,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: appText,
                ),
                Expanded(
                  child: Text(
                    "KREDİ KARTI BİLGİLERİ",
                    textAlign: TextAlign.center,
                    style:
                        normalTextStyle.copyWith(color: appText, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: pan,
                cardHolderName: '$firstName $lastName',
                expiryDate: '$expiryMonth/$expiryYear',
                cvvCode: cvv,
                showBackView: isCvvFocused,
                cardBgColor: primary,
                onCreditCardWidgetChange: (CreditCardBrand brand) {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: border,
                            labelStyle:
                                normalTextStyle.copyWith(color: primary),
                            labelText: 'Kart Numarası',
                            enabledBorder: enableBorder,
                            focusedBorder: focusBorder,
                          ),

                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              pan = value;
                            });
                            if (value.length >= 6) {
                              fetchBinDetails(value.substring(0, 6));
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: border,
                            labelStyle:
                                normalTextStyle.copyWith(color: primary),
                            labelText: 'Kart Sahibinin Adı',
                            enabledBorder: enableBorder,
                            focusedBorder: focusBorder,
                          ),
                          onChanged: (value) {
                            setState(() {
                              final names = value.split(' ');
                              firstName = names[0];
                              lastName = names.length > 1 ? names[1] : '';
                            });
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: border,
                                  labelStyle:
                                      normalTextStyle.copyWith(color: primary),
                                  labelText: 'MM/YY',
                                  enabledBorder: enableBorder,
                                  focusedBorder: focusBorder,
                                ),
                                keyboardType: TextInputType.datetime,
                                onChanged: (value) {
                                  setState(() {
                                    final parts = value.split('/');
                                    if (parts.length == 2) {
                                      expiryMonth = parts[0];
                                      expiryYear = parts[1];
                                    } else {
                                      expiryMonth = '';
                                      expiryYear = '';
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  setState(() {
                                    isCvvFocused = hasFocus;
                                  });
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: border,
                                    labelStyle: normalTextStyle.copyWith(color: primary),
                                    labelText: 'CVV',
                                    enabledBorder: enableBorder,
                                    focusedBorder: focusBorder,
                                  ),
                                  obscureText: true,
                                  cursorColor: primary,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      cvv = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      if (currency.isNotEmpty && bank.isNotEmpty) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: border,
                                    labelStyle: normalTextStyle.copyWith(
                                        color: primary),
                                    labelText: 'Para Birimi',
                                    enabledBorder: enableBorder,
                                    focusedBorder: focusBorder,
                                  ),
                                  value: currencyOptions.contains(currency)
                                      ? currency
                                      : null,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      currency = newValue!;
                                    });
                                  },
                                  items: currencyOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: border,
                                    labelStyle: normalTextStyle.copyWith(
                                        color: primary),
                                    labelText: 'Banka',
                                    enabledBorder: enableBorder,
                                    focusedBorder: focusBorder,
                                  ),
                                  initialValue: bank,
                                  enabled: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (installmentOptions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: border,
                              labelStyle:
                                  normalTextStyle.copyWith(color: primary),
                              labelText: 'Taksit Seçenekleri',
                              enabledBorder: enableBorder,
                              focusedBorder: focusBorder,
                            ),
                            value: selectedInstallments.isNotEmpty
                                ? selectedInstallments
                                : null,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedInstallments = newValue!;
                              });
                            },
                            items: installmentOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: border,
                            labelStyle:
                                normalTextStyle.copyWith(color: primary),
                            labelText: 'Ödeme Tutarı',
                            enabledBorder: enableBorder,
                            focusedBorder: focusBorder,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              paymentAmount = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: radius,
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              sendPaymentData();
                            }
                          },
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Öde',
                            style: boldTextStyle.copyWith(
                                color: appText, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
