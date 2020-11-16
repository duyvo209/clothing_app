// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Map<String, Address> addressFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Address>(k, Address.fromJson(v)));

String addressToJson(Map<String, Address> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Address {
  Address({
    this.name,
    this.districts,
  });

  String name;
  Map<String, String> districts;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json["name"],
        districts: Map.from(json["districts"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "districts":
            Map.from(districts).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
