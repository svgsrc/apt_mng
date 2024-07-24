import 'dart:convert';
import 'package:talya_flutter/Modules/Models/Apartment.dart';

class Contact {
  final Apartment apartmentInfo;


  Contact({required this.apartmentInfo});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      apartmentInfo: Apartment.fromJson(json),

    );
  }
}

// JSON data
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
        "phone": "05425686970",
        "plateNumber": "34 ABC 123",
        "email": "example7@gmail.com",
        "numberOfPeople": 4,
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "KEMAL ORAL",
        "ownerPhone": "05332708476",
        "balance": 0.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]
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
        "email": "sevgisarica7@gmail.com",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "EMEL EREĞLİ",
        "ownerPhone": "05332708477",
        "balance": 50.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]

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
        "email": "sevgisarica7@gmail.com",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "AYŞE YILMAZ",
        "ownerPhone": "05332708477",
        "balance": 600.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]

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
        "plateNumber": "01 BS 2606",
        "email": "sevgisarica7@gmail.com",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "DOĞAN SARI",
        "ownerPhone": "05332708477",
        "balance": 50.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]
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
        "plateNumber": "34 YZ 130",
        "email": "sevgisarica7@gmail.com",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "HATİCE ÇETİN",
        "ownerPhone": "05332708477",
        "balance": 50.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]

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
        "plateNumber": "10 AB 2416",
        "email": "sevgisarica7@gmail.com",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "ALİ KOÇ",
        "ownerPhone": "05332708477",
        "balance": 50.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]
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
        "plateNumber": "07 DCB 146",
        "email": "sevgisarica7@gmail.com",
        "startDate": "01/06/2024",
        "endDate": "01/07/2025",
        "ownerName": "MUSTAFA SANDAL",
        "ownerPhone": "05332708477",
        "balance": 150.00
      },
      "fees": [
        {
          "feeType": "Monthly Fee",
          "feeAmount": 200.00,
          "feeDate": "01/06/2024"
        },
        {
          "feeType": "General Expenses",
          "feeAmount": 250.00,
          "feeDate": "05/06/2024"
        },
        {
          "feeType": "Fixed Assets",
          "feeAmount": 150.00,
          "feeDate": "18/06/2024"
        }
      ]
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