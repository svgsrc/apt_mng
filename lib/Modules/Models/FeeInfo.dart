
class Fee{
  final String feeType;
  final double feeAmount;
  final String feeDate;


  Fee({
    required this.feeType,
    required this.feeAmount,
    required this.feeDate,

  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      feeType: json['feeType'] as String? ?? 'N/A',
      feeAmount: (json['feeAmount'] as num).toDouble(),
      feeDate: json['feeDate'] as String? ?? 'N/A',

    );
  }

}