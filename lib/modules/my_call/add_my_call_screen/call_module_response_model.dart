import 'dart:convert';

CallModuleResponseModel callModuleResponseModelFromJson(String str) => CallModuleResponseModel.fromJson(json.decode(str));

String callModuleResponseModelToJson(CallModuleResponseModel data) => json.encode(data.toJson());

class CallModuleResponseModel {
  final bool success;
  final List<CallType> data;
  final int totalCount;

  CallModuleResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory CallModuleResponseModel.fromJson(Map<String, dynamic> json) => CallModuleResponseModel(
    success: json["success"],
    data: List<CallType>.from(json["data"].map((x) => CallType.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class CallType {
  final String codeType;
  final String codeId;
  final String codeDesc;

  CallType({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory CallType.fromJson(Map<String, dynamic> json) => CallType(
    codeType: json["codeType"] ?? "",
    codeId: json["codeId"] ?? "",
    codeDesc: json["codeDesc"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "codeType": codeType,
    "codeId": codeId,
    "codeDesc": codeDesc,
  };
}
