import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:duyvo/models/province.dart';
import 'package:duyvo/models/Address.dart';

class Api {
  Future<void> getAllProvincesOfVietNam(
      {Function(List<Address>) onSuccess, Function(String) onError}) async {
    String endpoint =
        'https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/json/all.json?fbclid=IwAR2XDqlDZ4FTcHT0-1I8uGYuyiHc5n9U8-Cjji4rBp9CveYhtHSTGag3rPk';
    List<Address> provices = List();
    http.Response response = await http.get(endpoint);
    if (response.statusCode == 200) {
      try {
        dynamic jsonRaw = json.decode(response.body);
        List<dynamic> data = jsonRaw;
        data.forEach((p) {
          provices.add(Address.fromJson(p));
        });
        onSuccess(provices);
      } catch (e) {
        onError("Something get wrong!");
      }
    } else {
      onError("Something get wrong! Status code ${response.statusCode}");
    }
  }
}
