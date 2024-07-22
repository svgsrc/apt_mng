import 'package:flutter/foundation.dart';

class ApartmentInfo {
  final String apartmentName;
  final String blockName;
  final int flatNumber;
  final String residentName;
  final String idNo;
  final String phone;
  final String plateNumber;
  final String email;
  final int numberOfPeople;
  final String startDate;
  final String endDate;
  final String ownerName;
  final String ownerPhone;
  final double balance;




  ApartmentInfo({
    required this.apartmentName,
    required this.blockName,
    required this.flatNumber,
    required this.residentName,
    required this.idNo,
    required this.phone,
    required this.plateNumber,
    required this.email,
    required this.numberOfPeople,
    required this.startDate,
    required this.endDate,
    required this.ownerName,
    required this.ownerPhone,
    required this.balance,


  });

  factory ApartmentInfo.fromJson(Map<String, dynamic> json) {

    return ApartmentInfo(
      apartmentName: json['apartmentName'] ?? 'N/A',
      blockName: json['blockName'] ?? 'N/A',
      flatNumber: json['flatNumber'] ?? 0,
      residentName: json['residentName'] ?? 'N/A',
      idNo: json['idNo'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      plateNumber: json['plateNumber'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      numberOfPeople: json['numberOfPeople'] ?? 0,
      startDate: json['startDate'] ?? 'N/A',
      endDate: json['endDate'] ?? 'N/A',
      ownerName: json['ownerName'] ?? 'N/A',
      ownerPhone: json['ownerPhone'] ?? 'N/A',
      balance: (json['balance'] ?? 0.0).toDouble(),

    );
  }
}




class Contact {
  final ApartmentInfo apartmentInfo;

  Contact({required this.apartmentInfo});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      apartmentInfo: ApartmentInfo.fromJson(json),
    );
  }
}
