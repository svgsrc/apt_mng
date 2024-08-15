import 'package:talya_flutter/Modules/Models/Fee.dart';

class Apartment {
  final int id;
  final int hotelId;
  final String name;
  final String blockName;
  final String flatNumber;
  final String contactName;
  final String phone;
  final String idNo;
  final int numberOfPeople;
  final String plateNo;
  final String ownerName;
  final String ownerPhone;
  final int balance;
  final String startDate;
  final String endDate;
  final bool isDisabled;
  final String photoUrl;
  final String email;

  Apartment({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.blockName,
    required this.flatNumber,
    required this.contactName,
    required this.phone,
    required this.idNo,
    required this.numberOfPeople,
    required this.plateNo,
    required this.ownerName,
    required this.ownerPhone,
    required this.balance,
    required this.startDate,
    required this.endDate,
    required this.isDisabled,
    required this.photoUrl,
    required this.email,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['ID'] ?? 0,
      hotelId: json['HOTELID'] ?? 0,
      name: json['NAME'] ?? '',
      blockName: json['BLOCKNAME'] ?? '',
      flatNumber: json['FLATNUMBER'] ?? '',
      contactName: json['CONTACTNAME'] ?? '',
      phone: json['PHONE'] ?? '',
      idNo: json['IDNO'] ?? '',
      numberOfPeople: json['NUMBEROFPEOPLE'] ?? 0,
      plateNo: json['PLATENO'] ?? '',
      ownerName: json['OWNERNAME'] ?? '',
      ownerPhone: json['OWNERPHONE'] ?? '',
      balance: json['BALANCE'] ?? 0,
      startDate: json['STARTDATE'] ?? '',
      endDate: json['ENDDATE'] ?? '',
      isDisabled: json['ISDISABLED'] ?? false,
      photoUrl: json['PHOTOURL'] ?? '',
      email: json['EMAIL'] ?? '',
    );
  }
}
