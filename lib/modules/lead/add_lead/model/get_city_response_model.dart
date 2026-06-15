import 'dart:convert';

GetCityResponseModel getCityResponseModelFromJson(String str) => GetCityResponseModel.fromJson(json.decode(str));

String getCityResponseModelToJson(GetCityResponseModel data) => json.encode(data.toJson());

class GetCityResponseModel {
  final bool isSuccess;
  final List<City> data;

  GetCityResponseModel({
    required this.isSuccess,
    required this.data,
  });

  factory GetCityResponseModel.fromJson(Map<String, dynamic> json) => GetCityResponseModel(
        isSuccess: json["success"],
        data: List<City>.from(json["data"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": isSuccess,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class City {
  final String location;
  final int cityCode;

  City({
    required this.location,
    required this.cityCode,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        location: json["location"],
        cityCode: json["city_code"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "city_code": cityCode,
      };
}