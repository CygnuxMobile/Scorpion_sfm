// To parse this JSON data, do
//
//     final getIndustryTypeResponseModel = getIndustryTypeResponseModelFromJson(jsonString);

import 'dart:convert';

GetIndustryTypeResponseModel getIndustryTypeResponseModelFromJson(String str) => GetIndustryTypeResponseModel.fromJson(json.decode(str));

String getIndustryTypeResponseModelToJson(GetIndustryTypeResponseModel data) => json.encode(data.toJson());

class GetIndustryTypeResponseModel {
  final bool success;
  final List<IndustryType> data;
  final int totalCount;

  GetIndustryTypeResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetIndustryTypeResponseModel.fromJson(Map<String, dynamic> json) => GetIndustryTypeResponseModel(
        success: json["success"],
        data: List<IndustryType>.from(json["data"].map((x) => IndustryType.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class IndustryType {
  final String codeType;
  final String codeId;
  final String codeDesc;

  IndustryType({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory IndustryType.fromJson(Map<String, dynamic> json) => IndustryType(
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
