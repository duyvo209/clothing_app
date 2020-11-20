// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

List<Address> addressFromJson(String str) =>
    List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(List<Address> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Huyen {
  Huyen({
    this.id,
    this.name,
    this.location,
    this.type,
    this.tinhId,
    this.xa,
  });

  int id;
  String name;
  String location;
  HuyenType type;
  int tinhId;
  List<Address> xa;

  factory Huyen.fromJson(Map<String, dynamic> json) => Huyen(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        type: huyenTypeValues.map[json["type"]],
        tinhId: json["tinh_id"],
        xa: List<Address>.from(json["xa"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "type": huyenTypeValues.reverse[type],
        "tinh_id": tinhId,
        "xa": List<dynamic>.from(xa.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    this.id,
    this.name,
    this.location,
    this.type,
    this.huyen,
    this.huyenId,
  });

  int id;
  String name;
  String location;
  AddressType type;
  List<Huyen> huyen;
  int huyenId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        type: addressTypeValues.map[json["type"]],
        huyen: json["huyen"] == null
            ? null
            : List<Huyen>.from(json["huyen"].map((x) => Huyen.fromJson(x))),
        huyenId: json["huyen_id"] == null ? null : json["huyen_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "type": addressTypeValues.reverse[type],
        "huyen": huyen == null
            ? null
            : List<dynamic>.from(huyen.map((x) => x.toJson())),
        "huyen_id": huyenId == null ? null : huyenId,
      };
}

enum HuyenType { QUN, HUYN, TH_X, THNH_PH }

final huyenTypeValues = EnumValues({
  "Huyện": HuyenType.HUYN,
  "Quận": HuyenType.QUN,
  "Thành phố": HuyenType.THNH_PH,
  "Thị xã": HuyenType.TH_X
});

enum AddressType { THNH_PH_TRUNG_NG, TNH, PHNG, TH_TRN, X }

final addressTypeValues = EnumValues({
  "Phường": AddressType.PHNG,
  "Thành phố Trung ương": AddressType.THNH_PH_TRUNG_NG,
  "Thị trấn": AddressType.TH_TRN,
  "Tỉnh": AddressType.TNH,
  "Xã": AddressType.X
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
