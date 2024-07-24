import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class APIServiceFlats {
  Stream<List<Apartment>> fetchApartments() async* {
    final url = 'https://4001.hoteladvisor.net';

    final Map<String, dynamic> requestBody = {
      "Action": "Execute",
      "Object": "SP_MOBILE_APARTMENT_FLATS_LIST",
      "Parameters": {
        "BLOCKNAME": "A BLOK",
        "HOTELID": 20854,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Apartment> apartments = (data[0] as List)
            .map((apartment) => Apartment.fromJson(apartment))
            .toList();
        yield apartments;
      } else {
        throw Exception("Failed to load apartments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load apartments: $e");
    }
  }
}
