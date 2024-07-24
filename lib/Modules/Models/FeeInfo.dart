
class FeeInfo{
  final String feeType;
  final double feeAmount;
  final String feeDate;


  FeeInfo({
    required this.feeType,
    required this.feeAmount,
    required this.feeDate,

  });

  factory FeeInfo.fromJson(Map<String, dynamic> json) {
    return FeeInfo(
      feeType: json['feeType'] as String? ?? 'N/A',
      feeAmount: (json['feeAmount'] ).toDouble(),
      feeDate: json['feeDate'] as String? ?? 'N/A',

    );
  }

}