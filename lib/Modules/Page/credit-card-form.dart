import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:talya_flutter/Global/constants.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';

class CreditCardFormScreen extends StatefulWidget {
   final List<Fee> fees;

  CreditCardFormScreen({required this.fees});

  @override
  _CreditCardFormScreenState createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String paymentAmount = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    paymentAmount = widget.fees[0].paymentAmount.toString();
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
          toolbarHeight: 25,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [appBar2, appBar1],
              ),
            ),
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
                    style: normalTextStyle.copyWith(
                        color: appText, fontSize: 20),
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
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (CreditCardBrand brand) {},
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                autovalidateMode: AutovalidateMode.disabled,
                disableCardNumberAutoFillHints: false,
                inputConfiguration: InputConfiguration(
                  cardHolderDecoration: InputDecoration(
                    border: border,
                    labelStyle: normalTextStyle.copyWith(color: primary),
                    labelText: 'Kart Sahibi',
                    enabledBorder: enableBorder,
                    focusedBorder: focusBorder,
                  ),
                  cardNumberDecoration: InputDecoration(
                    border: border,
                    labelStyle: normalTextStyle.copyWith(color: primary),
                    labelText: 'Kart Numarası',
                    enabledBorder: enableBorder,
                    focusedBorder: focusBorder,
                  ),
                  expiryDateDecoration: InputDecoration(
                    border: border,
                    labelStyle: normalTextStyle.copyWith(color: primary),
                    labelText: 'SKT',
                    enabledBorder: enableBorder,
                    focusedBorder: focusBorder,
                  ),
                  cvvCodeDecoration: InputDecoration(
                    border: border,
                    labelStyle: normalTextStyle.copyWith(color: primary),
                    labelText: 'CVV',
                    enabledBorder: enableBorder,
                    focusedBorder: focusBorder,
                  ),
                ),
                onCreditCardModelChange: (CreditCardModel? model) {
                  setState(() {
                    cardNumber = model?.cardNumber ?? '';
                    expiryDate = model?.expiryDate ?? '';
                    cardHolderName = model?.cardHolderName ?? '';
                    cvvCode = model?.cvvCode ?? '';
                    isCvvFocused = model?.isCvvFocused ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: border,
                    labelStyle: normalTextStyle.copyWith(color: primary),
                    labelText: 'Ödeme Tutarı',
                    enabledBorder: enableBorder,
                    focusedBorder: focusBorder,
                  ),
                  onChanged: (value) {
                    setState(() {
                      paymentAmount = value;

                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: radius,
                ),
                child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      print('Ödeme Tutarı: $paymentAmount');
                    }
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Öde',
                    style: boldTextStyle.copyWith(
                      color: appText,
                      fontSize: 14,
                    ),
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
