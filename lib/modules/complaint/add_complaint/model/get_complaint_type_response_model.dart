import 'dart:convert';

ComplaintTypeResponseModel complaintTypeResponseModelFromJson(String str) => ComplaintTypeResponseModel.fromJson(json.decode(str));

String complaintTypeResponseModelToJson(ComplaintTypeResponseModel data) => json.encode(data.toJson());

class ComplaintTypeResponseModel {
  final bool success;
  final List<ComplaintTypeDatum> complaintTypeData;
  final int totalCount;

  ComplaintTypeResponseModel({
    required this.success,
    required this.complaintTypeData,
    required this.totalCount,
  });

  factory ComplaintTypeResponseModel.fromJson(Map<String, dynamic> json) => ComplaintTypeResponseModel(
    success: json["success"],
    complaintTypeData: List<ComplaintTypeDatum>.from(json["data"].map((x) => ComplaintTypeDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "complaintTypeData": List<dynamic>.from(complaintTypeData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class ComplaintTypeDatum {
  final String codeType;
  final String codeId;
  final String codeDesc;

  ComplaintTypeDatum({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory ComplaintTypeDatum.fromJson(Map<String, dynamic> json) => ComplaintTypeDatum(
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
