import 'dart:convert';

ComplaintSubTypeResponseModel complaintSubTypeResponseModelFromJson(String str) => ComplaintSubTypeResponseModel.fromJson(json.decode(str));

String complaintSubTypeResponseModelToJson(ComplaintSubTypeResponseModel data) => json.encode(data.toJson());

class ComplaintSubTypeResponseModel {
  final bool success;
  final List<ComplaintSubTypeDatum> complaintSubTypeData;
  final int totalCount;

  ComplaintSubTypeResponseModel({
    required this.success,
    required this.complaintSubTypeData,
    required this.totalCount,
  });

  factory ComplaintSubTypeResponseModel.fromJson(Map<String, dynamic> json) => ComplaintSubTypeResponseModel(
    success: json["success"],
    complaintSubTypeData: List<ComplaintSubTypeDatum>.from(json["data"].map((x) => ComplaintSubTypeDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "complaintSubTypeData": List<dynamic>.from(complaintSubTypeData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class ComplaintSubTypeDatum {
  final String codeType;
  final String codeId;
  final String codeDesc;

  ComplaintSubTypeDatum({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory ComplaintSubTypeDatum.fromJson(Map<String, dynamic> json) => ComplaintSubTypeDatum(
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
