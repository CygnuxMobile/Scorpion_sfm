// To parse this JSON data, do
//
//     final getLeadSourceResponseModel = getLeadSourceResponseModelFromJson(jsonString);

import 'dart:convert';

GetLeadSourceResponseModel getLeadSourceResponseModelFromJson(String str) => GetLeadSourceResponseModel.fromJson(json.decode(str));

String getLeadSourceResponseModelToJson(GetLeadSourceResponseModel data) => json.encode(data.toJson());

class GetLeadSourceResponseModel {
  final bool success;
  final List<LeadSource> data;
  final int totalCount;

  GetLeadSourceResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetLeadSourceResponseModel.fromJson(Map<String, dynamic> json) => GetLeadSourceResponseModel(
        success: json["success"],
        data: List<LeadSource>.from(json["data"].map((x) => LeadSource.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class LeadSource {
  final String codeType;
  final String codeId;
  final String codeDesc;

  LeadSource({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory LeadSource.fromJson(Map<String, dynamic> json) => LeadSource(
        codeType: json["codeType"]??"",
        codeId: json["codeId"]??"",
        codeDesc: json["codeDesc"]??"",
      );

  Map<String, dynamic> toJson() => {
        "codeType": codeType,
        "codeId": codeId,
        "codeDesc": codeDesc,
      };
}
