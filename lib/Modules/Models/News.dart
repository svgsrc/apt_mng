class News {
  final int id;
  final int hotelId;
  final String content;
  final DateTime startDate;
  final DateTime endDate;

  News({
    required this.id,
    required this.hotelId,
    required this.content,
    required this.startDate,
    required this.endDate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['ID'] ?? 0,
      hotelId: json['HOTELID'] ?? 0,
      content: json['CONTENT'] ?? '',
      startDate: DateTime.parse(json['STARTDATE'] ?? ''),
      endDate: DateTime.parse(json['ENDDATE'] ?? ''),
    );
  }

}