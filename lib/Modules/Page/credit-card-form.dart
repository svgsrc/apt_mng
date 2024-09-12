import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:talya_flutter/Modules/Models/Payment.dart';
import 'package:talya_flutter/Modules/Page/webView-page.dart';

class CreditCardFormScreen extends StatefulWidget {
  final List<Fee> fees;
  final Apartment apartment;

  CreditCardFormScreen(
      {super.key, required this.fees, required this.apartment});

  @override
  _CreditCardFormScreenState createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  final PaymentModel paymentModel = PaymentModel();
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

    paymentModel.updateData('feeUid', fetchedFee.uid);
    paymentModel.updateData(
        'paymentAmount', fetchedFee.feeAmount.toStringAsFixed(2));
  }

  String generateHashData(Map<String, dynamic> formData) {
    String data =
        '${formData['firstName']}${formData['lastName']}${formData['pan']}${formData['expiryMonth']}${formData['expiryYear']}${formData['cvv']}${formData['paymentAmount']}${formData['currency']}${formData['bank']}';
    var bytes = utf8.encode(data);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>> sendPaymentData(
      Map<String, dynamic> formData) async {
    final paymentData = {
      "hotelId": widget.apartment.hotelId,
      "feeUid": formData['feeUid'],
      "firstName": formData['firstName'],
      "lastName": formData['lastName'],
      "pan": formData['pan'],
      "expiryMonth": formData['expiryMonth'],
      "expiryYear": formData['expiryYear'],
      "cvv": formData['cvv'],
      "amount": formData['paymentAmount'],
      "currency": formData['currency'],
      "bank": formData['bank'],
      "redirectMode": "backend",
      "hashData": generateHashData(formData),
      "selectedInstallments":
          '{"installment":"${formData['selectedInstallments']}","finalPrice":"${formData['paymentAmount']}"}',
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

        return responseData;
      } else {
        debugPrint(
            'Ödeme işleme başarısız oldu. Durum Kodu: ${response.statusCode}');
        return {
          "error":
              'Ödeme işleme başarısız oldu. Durum Kodu: ${response.statusCode}'
        };
      }
    } catch (e) {
      debugPrint('Ödeme işleme hatası: $e');
      return {"error": 'Ödeme işleme hatası: $e'};
    }
  }

  Future<void> fetchBinDetails(String pan) async {
    String binNumber = pan.substring(0, 6);

    if (!RegExp(r'^\d{6}$').hasMatch(binNumber)) {
      debugPrint('Hata: Geçersiz BIN numarası formatı.');
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

        final bankInfo = data['bankInfo'];
        if (bankInfo != null && bankInfo['success'] == true) {
          final bankData = bankInfo['data'];
          final bankConfig = bankData['bankConfig'];
          paymentModel.updateData('bank', bankData['bankName'] ?? '');
          paymentModel.updateData(
              'currencyOptions',
              bankConfig['currency'] != null
                  ? List<String>.from(bankConfig['currency'])
                  : []);
          paymentModel.updateData(
              'installmentOptions',
              bankConfig['installment'] != null
                  ? List<String>.from(bankConfig['installment'])
                  : []);
          paymentModel.updateData(
              'currency',
              paymentModel.formData$.value['currencyOptions'].isNotEmpty
                  ? paymentModel.formData$.value['currencyOptions'][0]
                  : '');
        } else {
          debugPrint('Bank bilgisi alınamadı veya başarı durumu false döndü.');
        }
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(
            'BIN bilgileri alınamadı. Kod: ${response.statusCode}, Hata: ${errorData['error']}');
      }
    } catch (e) {
      debugPrint('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            child: StreamBuilder(
                stream: paymentModel.formData$.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...',
                        style: boldTextStyle.copyWith(
                            color: appText, fontSize: 20));
                  }
                  final formData = snapshot.data;
                  return Column(
                    children: [
                      CreditCardWidget(
                        cardNumber: formData?['pan'],
                        cardHolderName:
                            '${formData?['firstName']} ${formData?['lastName']}',
                        expiryDate:
                            '${formData?['expiryMonth']}/${formData?['expiryYear']}',
                        cvvCode: formData?['cvv'],
                        showBackView: formData?['isCvvFocused'],
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
                                    labelStyle: normalTextStyle.copyWith(
                                        color: primary),
                                    labelText: 'Kart Numarası',
                                    enabledBorder: enableBorder,
                                    focusedBorder: focusBorder,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    paymentModel.updateData('pan', value);
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
                                    labelStyle: normalTextStyle.copyWith(
                                        color: primary),
                                    labelText: 'Kart Sahibinin Adı',
                                    enabledBorder: enableBorder,
                                    focusedBorder: focusBorder,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      final names = value.split(' ');
                                      paymentModel.updateData(
                                          'firstName', names[0]);
                                      paymentModel.updateData('lastName',
                                          names.length > 1 ? names[1] : '');
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
                                          labelStyle: normalTextStyle.copyWith(
                                              color: primary),
                                          labelText: 'MM/YY',
                                          enabledBorder: enableBorder,
                                          focusedBorder: focusBorder,
                                        ),
                                        keyboardType: TextInputType.datetime,
                                        onChanged: (value) {
                                          setState(() {
                                            final parts = value.split('/');
                                            if (parts.length == 2) {
                                              paymentModel.updateData(
                                                  'expiryMonth', parts[0]);
                                              paymentModel.updateData(
                                                  'expiryYear', parts[1]);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Focus(
                                        onFocusChange: (isFocused) {
                                          paymentModel.updateData(
                                              'isCvvFocused', isFocused);
                                        },
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: border,
                                            labelStyle: normalTextStyle
                                                .copyWith(color: primary),
                                            labelText: 'CVV',
                                            enabledBorder: enableBorder,
                                            focusedBorder: focusBorder,
                                          ),
                                          obscureText: true,
                                          cursorColor: primary,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            paymentModel.updateData(
                                                'cvv', value);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (formData?['currency'] != null &&
                                  formData?['currency'].isNotEmpty &&
                                  formData?['bank'] != null &&
                                  formData?['bank'].isNotEmpty) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: border,
                                            labelStyle: normalTextStyle
                                                .copyWith(color: primary),
                                            labelText: 'Para Birimi',
                                            enabledBorder: enableBorder,
                                            focusedBorder: focusBorder,
                                          ),
                                          value: paymentModel.formData$
                                                  .value['currencyOptions']
                                                  .contains(paymentModel
                                                      .formData$
                                                      .value['currency'])
                                              ? paymentModel
                                                  .formData$.value['currency']
                                              : null,
                                          onChanged: (String? newValue) {
                                            paymentModel.updateData(
                                                'cvv', newValue);
                                          },
                                          items: formData?['currencyOptions']
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
                                            labelStyle: normalTextStyle
                                                .copyWith(color: primary),
                                            labelText: 'Banka',
                                            enabledBorder: enableBorder,
                                            focusedBorder: focusBorder,
                                          ),
                                          initialValue: formData?['bank'],
                                          enabled: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (formData?['installmentOptions'].isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      border: border,
                                      labelStyle: normalTextStyle.copyWith(
                                          color: primary),
                                      labelText: 'Taksit Seçenekleri',
                                      enabledBorder: enableBorder,
                                      focusedBorder: focusBorder,
                                    ),
                                    value: (paymentModel.formData$.value[
                                                    'selectedInstallments'] !=
                                                null &&
                                            paymentModel
                                                .formData$
                                                .value['selectedInstallments']
                                                .isNotEmpty)
                                        ? paymentModel.formData$
                                            .value['selectedInstallments']
                                        : null,
                                    onChanged: (String? newValue) {
                                      paymentModel.updateData(
                                          'selectedInstallments', newValue);
                                    },
                                    items: formData?['installmentOptions']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                    labelStyle: normalTextStyle.copyWith(
                                        color: primary),
                                    labelText: 'Ödeme Tutarı',
                                    enabledBorder: enableBorder,
                                    focusedBorder: focusBorder,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    paymentModel.updateData(
                                        'paymentAmount', value);
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
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      var paymentData = await sendPaymentData(
                                          paymentModel.formData$.value);

                                      if (paymentData["error"] != null) {
                                        debugPrint(paymentData["error"]);
                                      } else if (paymentData["data"] != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebViewScreen(
                                              htmlContent: paymentData["data"],
                                              apartment: widget.apartment,
                                              fees: widget.fees,
                                            ),
                                          ),
                                        ).then((paymentResult) {
                                          if (paymentResult == true) {
                                            debugPrint('Ödeme başarılı.');
                                            Navigator.pop(context, [true]);
                                          }
                                        });
                                      }
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
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
                  );
                })),
      ),
    );
  }
}
