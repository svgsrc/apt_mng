import 'dart:convert';
import 'package:talya_flutter/Modules/Models/ApartmentInfo.dart';

final String jsonData = '''
{
  "apartments": [
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 1,
        "residentName": "ANIL ERDOĞAN",
        "idNo": "11111111111",
        "phone": "+905425686970",
        "plateNumber": "34 ABC 123",
        "numberOfPeople": 4,
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "KEMAL ORAL",
        "ownerPhone": "05332708476",
        "balance": 0.00
      }
    },
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 2,
        "residentName": "BATU ÖZLER",
        "idNo": "22222222222",
        "phone": "05326445397",
        "numberOfPeople": 3,
        "plateNumber": null,
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "EMEL EREĞLİ",
        "ownerPhone": "05332708477",
        "balance": 50.00
      }

    },
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 3,
        "residentName": "AYŞE YILMAZ",
        "idNo": "22222222222",
        "phone": "05326445397",
        "numberOfPeople": 5,
        "plateNumber": "34 ABC 123",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "AYŞE YILMAZ",
        "ownerPhone": "05332708477",
        "balance": 50.00
      }

    },
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 4,
        "residentName": "DOĞAN SARI",
        "idNo": "22222222222",
        "phone": "05326445397",
        "numberOfPeople": 3,
        "plateNumber": "12345",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "DOĞAN SARI",
        "ownerPhone": "05332708477",
        "balance": 50.00
      }
    },
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 5,
        "residentName": "BERKAN ÖZ",
        "idNo": "22222222222",
        "phone": "05326445397",
        "numberOfPeople": 1,
        "plateNumber": "12345",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "HATİCE ÇETİN",
        "ownerPhone": "05332708477",
        "balance": 50.00
      }

    },
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 6,
        "residentName": "FERDİ KADIOĞLU",
        "idNo": "22222222222",
        "phone": "05326445397",
        "numberOfPeople": 2,
        "plateNumber": "12345",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "ALİ KOÇ",
        "ownerPhone": "05332708477",
        "balance": 50.00
      }
    },
    {
      "apartmentInfo": {
        "apartmentName": "KINACI REZIDANS",
        "blockName": "A BLOK",
        "flatNumber": 7,
        "residentName": "MEHMET UZUN",
        "idNo": "22222222222",
        "phone": "05326445397",
        "numberOfPeople": 4,
        "plateNumber": "12345",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "MUSTAFA SANDAL",
        "ownerPhone": "05332708477",
        "balance": 50.00
      }
    }

  ]
}
''';

List<Contact> parseContacts(String jsonData) {
  final data = json.decode(jsonData);
  final apartments = data['apartments'] as List;
  return apartments.map((json) => Contact.fromJson(json)).toList();
}

final List<Contact> contacts = parseContacts(jsonData);
