import 'package:rxdart/rxdart.dart';

class PaymentModel {
  final BehaviorSubject<Map<String, dynamic>> formData$ =
      BehaviorSubject<Map<String, dynamic>>.seeded({
    'pan': '',
    'expiryMonth': '',
    'expiryYear': '',
    'firstName': '',
    'lastName': '',
    'cvv': '',
    'paymentAmount': '0.00',
    'feeUid': '',
    'isCvvFocused': false,
    'selectedInstallments': '',
    'currency': '',
    'bank': '',
    'currencyOptions': [],
    'installmentOptions': [],
  });

  Stream<Map<String, dynamic>> get formDataStream => formData$.stream;

  void updateData(String key, dynamic value) {
    formData$.value[key] = value;
    formData$.add(Map.from(formData$.value));
  }

  void dispose() {
    formData$.close();
  }
}
