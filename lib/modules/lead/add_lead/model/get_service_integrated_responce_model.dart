// To parse this JSON data, do
//
//     final getServiceIntegratedResponseModel = getServiceIntegratedResponseModelFromJson(jsonString);

import 'dart:convert';

GetServiceIntegratedResponseModel getServiceIntegratedResponseModelFromJson(String str) => GetServiceIntegratedResponseModel.fromJson(json.decode(str));

String getServiceIntegratedResponseModelToJson(GetServiceIntegratedResponseModel data) => json.encode(data.toJson());

class GetServiceIntegratedResponseModel {
  final bool success;
  final List<Service> data;
  final int totalCount;

  GetServiceIntegratedResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetServiceIntegratedResponseModel.fromJson(Map<String, dynamic> json) => GetServiceIntegratedResponseModel(
        success: json["success"],
        data: List<Service>.from(json["data"].map((x) => Service.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class Service {
  final String codeType;
  final String codeId;
  final String codeDesc;

  Service({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        codeType: json["codeType"],
        codeId: json["codeId"],
        codeDesc: json["codeDesc"],
      );

  Map<String, dynamic> toJson() => {
        "codeType": codeType,
        "codeId": codeId,
        "codeDesc": codeDesc,
      };
}
