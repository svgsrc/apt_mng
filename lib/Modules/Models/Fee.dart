class Fee {
  final int id;
  final int hotelId;
  final int flatId;
  final int feeTypeId;
  final String feeDate;
  final double feeAmount;
  final String paymentDate;
  final double paymentAmount;
  final String description;
  final String uid;
  bool isCompleted;

  Fee({
    required this.id,
    required this.hotelId,
    required this.flatId,
    required this.feeTypeId,
    required this.feeDate,
    required this.feeAmount,
    required this.paymentDate,
    required this.paymentAmount,
    required this.description,
    required this.uid,
    this.isCompleted = false,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      id: json['ID'] ?? 0,
      hotelId: json['HOTELID'] ?? 0,
      flatId: json['FLATID'] ?? 0,
      feeTypeId: json['FEETYPEID'] ?? 0,
      feeDate: json['FEEDATE'] ?? '',
      feeAmount: (json['FEEAMOUNT'] ?? 0.0).toDouble(),
      paymentDate: json['PAYMENTDATE'] ?? '',
      paymentAmount: (json['PAYMENTAMOUNT'] ?? 0.0).toDouble(),
      description: json['DESCRIPTION'] ?? '',
      uid: json['UID'] ?? '',
    );
  }
}
