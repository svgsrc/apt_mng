import 'package:rxdart/rxdart.dart';
import 'package:talya_flutter/Modules/Models/Apartment.dart';
import 'package:talya_flutter/Modules/Models/Fee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talya_flutter/Global/constants.dart';
import 'package:tuple/tuple.dart';


class APIService {

  BehaviorSubject<List<Apartment>?> apartments$= BehaviorSubject.seeded(null);
  BehaviorSubject<Map<int, List<Fee>?>> fees$= BehaviorSubject.seeded({});

  late final Stream<List<Apartment>?> apartmentsBroadcast;
  late final Stream<Map<int, List<Fee>?>> feesBroadcast;
  late final Stream<Tuple2<List<Apartment>?, Map<int, List<Fee>?>?>> combinedStream$;


  APIService(){
    apartmentsBroadcast=apartments$.stream.asBroadcastStream();
    feesBroadcast=fees$.stream.asBroadcastStream();

    combinedStream$=Rx.combineLatest2(
        apartments$,
        fees$,
            (List<Apartment>? apartments, Map<int, List<Fee>?>? fees){
      return Tuple2(apartments, fees);
    }
    ).asBroadcastStream();
  }


  Future <List<Apartment>> fetchApartments(String blockName,int hotelId)async{
    final Map<String, dynamic> requestBody = {
      "Action": "Execute",
      "Object": "SP_MOBILE_APARTMENT_FLATS_LIST",
      "Parameters": {
        "BLOCKNAME": "A BLOK",
        "HOTELID": 20854 ,
      }
    };

    try {
      var response = await http.post(
        Uri.parse(url+'/Execute/SP_MOBILE_APARTMENT_FLATS_LIST'),
        headers: {'User-Agent': 'appartmentApp_1.0.0'},
        body: json.encode(requestBody),
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
        if (data[0].isNotEmpty) {
          List<Fee> fees = [];
          data[0].forEach((fee) {
            fees.add(Fee.fromJson(fee));
          });
          final currentFees = fees$.value;
          currentFees[apartmentId] = fees;
          fees$.add(currentFees);
        }
      }
    } catch (e) {
      print("Failed to upload fees: $e");
    }
    return [];
  }

}




