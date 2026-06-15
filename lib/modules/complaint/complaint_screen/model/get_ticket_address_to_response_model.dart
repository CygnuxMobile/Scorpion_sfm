// To parse this JSON data, do
//
//     final getTicketAddressToResponseModel = getTicketAddressToResponseModelFromJson(jsonString);

import 'dart:convert';

GetTicketAddressToResponseModel getTicketAddressToResponseModelFromJson(String str) => GetTicketAddressToResponseModel.fromJson(json.decode(str));

String getTicketAddressToResponseModelToJson(GetTicketAddressToResponseModel data) => json.encode(data.toJson());

class GetTicketAddressToResponseModel {
  final bool success;
  final List<TicketAddressTo> data;
  final int totalCount;

  GetTicketAddressToResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory GetTicketAddressToResponseModel.fromJson(Map<String, dynamic> json) => GetTicketAddressToResponseModel(
    success: json["success"],
    data: List<TicketAddressTo>.from(json["data"].map((x) => TicketAddressTo.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class TicketAddressTo {
  final String locCode;
  final String locName;

  TicketAddressTo({
    required this.locCode,
    required this.locName,
  });

  factory TicketAddressTo.fromJson(Map<String, dynamic> json) => TicketAddressTo(
    locCode: json["locCode"],
    locName: json["locName"],
  );

  Map<String, dynamic> toJson() => {
    "locCode": locCode,
    "locName": locName,
  };
}
