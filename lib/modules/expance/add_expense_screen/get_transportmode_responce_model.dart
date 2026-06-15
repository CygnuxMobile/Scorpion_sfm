
import 'dart:convert';

GetTransportModeResponseModel getTransportModeResponseModelFromJson(String str) => GetTransportModeResponseModel.fromJson(json.decode(str));

String getTransportModeResponseModelToJson(GetTransportModeResponseModel data) => json.encode(data.toJson());

class GetTransportModeResponseModel {
  final bool success;
  final List<TransportMode> data;
  final int totalCount;

  GetTransportModeResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetTransportModeResponseModel.fromJson(Map<String, dynamic> json) => GetTransportModeResponseModel(
    success: json["success"],
    data: List<TransportMode>.from(json["data"].map((x) => TransportMode.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class TransportMode {
  final String codeType;
  final String codeId;
  final String codeDesc;

  TransportMode({
    required this.codeType,
    required this.codeId,
    required this.codeDesc,
  });

  factory TransportMode.fromJson(Map<String, dynamic> json) => TransportMode(
    codeType: json["codeType"] ?? '',
    codeId: json["codeId"] ?? '',
    codeDesc: json["codeDesc"] ??'',
  );

  Map<String, dynamic> toJson() => {
    "codeType": codeType,
    "codeId": codeId,
    "codeDesc": codeDesc,
  };
}
