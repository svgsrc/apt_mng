import 'package:rxdart/rxdart.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talya_flutter/Global/constants.dart';



class APIService {

  BehaviorSubject<List<Apartment>?> apartments$= BehaviorSubject.seeded(null);
  BehaviorSubject<List<Fee>?> fees$= BehaviorSubject.seeded(null);

  Future <List<Apartment>> fetchApartments(String blockName,int hotelId)async{
    final Map<String, dynamic> requestBody = {
      "Action": "Execute",
      "Object": "SP_MOBILE_APARTMENT_FLATS_LIST",
      "Parameters": {
        "BLOCKNAME": "A BLOK",
        "HOTELID": 20854
      }
    };

    try {
      var response = await http.post(
        Uri.parse(url+'/Execute/SP_MOBILE_APARTMENT_FLATS_LIST'),
        headers: {'User-Agent': 'appartmentApp_1.0.0'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);

          var data = json.decode(decodedResponse);
          if(data[0].isNotEmpty){
            List<Apartment> apartments = [];
            data[0].forEach((apartment) {
              apartments.add(Apartment.fromJson(apartment));
            });
            apartments$.add(apartments);
          }else {
            apartments$.add([]);
          }
      }else{
        print("HTTP Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to upload apartments: $e");
    }
    return [];
  }

  Future <List<Fee>> fetchFees(int apartmentId,int hotelId)async{
    final Map<String, dynamic> requestBody ={
      "Action": "Execute",
      "Object": "SP_MOBILE_APARTMENT_FEES_LIST",
      "Parameters": {
        "ID": apartmentId,
        "HOTELID": 20854
      }
    } ;

    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);

          var data = json.decode(decodedResponse);
          if(data[0].isNotEmpty){
            List<Fee> fees = [];
            data[0].forEach((fee) {
              fees.add(Fee.fromJson(fee));
            });
            fees$.add(fees);
          }else {
            fees$.add([]);
          }
      }
    } catch (e) {
      print("Failed to upload fees: $e");
    }
    return [];
  }

}




