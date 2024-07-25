import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talya_flutter/Global/constants.dart';



class APIService {


  Stream<List<Apartment>> fetchApartments() async* {
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
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);

        if (isJson(decodedResponse)) {
          final data = json.decode(decodedResponse);
          List<Apartment> apartments = (data[0] as List)
              .map((apartment) => Apartment.fromJson(apartment))
              .toList();
          yield apartments;
        } else {
          print('Incoming data is not in JSON format: $decodedResponse');
          throw Exception('Incoming data is not in JSON format');
        }
      } else {
        throw Exception("Failed to load apartments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load apartments: $e");
    }
  }

  Stream<List<Apartment>> fetchApartmentsBroadcast(){
    return fetchApartments().asBroadcastStream();
  }


  Stream<List<Fee>> fetchFees(int id) async* {
    final Map<String, dynamic> requestBody = {
      "Action": "Execute",
      "Object": "SP_MOBILE_APARTMENT_FEES_LIST",
      "Parameters": {
        "ID": id,
        "HOTELID": 20854
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);

        if (isJson(decodedResponse)) {
          final data = json.decode(decodedResponse);
          List<Fee> fees = (data[0] as List)
              .map((fee) => Fee.fromJson(fee))
              .toList();
          yield fees;
        } else {
          print('Incoming data is not in JSON format: $decodedResponse');
          throw Exception('Incoming data is not in JSON format');
        }
      } else {
        throw Exception("Failed to upload fees: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to upload fees: $e");
    }
  }

  Stream<List<Fee>> fetchFeesForApartment(int apartmentId) async* {
    await for (final fees in fetchFees(apartmentId)) {
      yield fees;
    }
  }

  bool isJson(String str) {
    try {
      json.decode(str);
    } catch (e) {
      return false;
    }
    return true;
  }
}

