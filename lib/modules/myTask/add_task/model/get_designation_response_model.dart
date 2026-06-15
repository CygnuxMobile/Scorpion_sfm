import 'dart:convert';

GetDesignationResponseModel getDesignationResponseModelFromJson(String str) => GetDesignationResponseModel.fromJson(json.decode(str));

String getDesignationResponseModelToJson(GetDesignationResponseModel data) => json.encode(data.toJson());

class GetDesignationResponseModel {
  final bool success;
  final List<Designation> data;
  final int totalCount;

  GetDesignationResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetDesignationResponseModel.fromJson(Map<String, dynamic> json) => GetDesignationResponseModel(
        success: json["success"],
        data: List<Designation>.from(json["data"].map((x) => Designation.fromJson(x))),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class Designation {
  final String codeType;
  final String codeId;
  final String codeDesc;

  Designation({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
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
