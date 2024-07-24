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
  final bool? isDisabled;

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
    this.isDisabled,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['ID'],
      hotelId: json['HOTELID'],
      name: json['NAME'],
      blockName: json['BLOCKNAME'],
      flatNumber: json['FLATNUMBER'],
      contactName: json['CONTACTNAME'],
      phone: json['PHONE'],
      idNo: json['IDNO'],
      numberOfPeople: json['NUMBEROFPEOPLE'],
      plateNo: json['PLATENO'],
      ownerName: json['OWNERNAME'],
      ownerPhone: json['OWNERPHONE'],
      balance: json['BALANCE'],
      startDate: json['STARTDATE'],
      endDate: json['ENDDATE'],
      isDisabled: json['ISDISABLED'],
    );
  }
}



