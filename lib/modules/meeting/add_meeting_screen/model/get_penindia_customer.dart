// To parse this JSON data, do
//
//     final panIndiaCustomerResponse = panIndiaCustomerResponseFromJson(jsonString);

import 'dart:convert';

PanIndiaCustomerResponse panIndiaCustomerResponseFromJson(String str) => PanIndiaCustomerResponse.fromJson(json.decode(str));

String panIndiaCustomerResponseToJson(PanIndiaCustomerResponse data) => json.encode(data.toJson());

class PanIndiaCustomerResponse {
  bool success;
  List<PanIndiaCustomer> data;
  int totalCount;

  PanIndiaCustomerResponse({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory PanIndiaCustomerResponse.fromJson(Map<String, dynamic> json) => PanIndiaCustomerResponse(
    success: json["success"],
    data: List<PanIndiaCustomer>.from(json["data"].map((x) => PanIndiaCustomer.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class PanIndiaCustomer {
  String customerCode;
  String customerName;

  PanIndiaCustomer({
    required this.customerCode,
    required this.customerName,
  });

  factory PanIndiaCustomer.fromJson(Map<String, dynamic> json) => PanIndiaCustomer(
    customerCode: json["customerCode"] ?? '',
    customerName: json["customerName"] ??'',
  );

  Map<String, dynamic> toJson() => {
    "customerCode": customerCode,
    "customerName": customerName,
  };
}
