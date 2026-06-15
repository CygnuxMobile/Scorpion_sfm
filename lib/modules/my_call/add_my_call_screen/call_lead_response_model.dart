import 'dart:convert';

CallLeadResponseModel callLeadResponseModelFromJson(String str) => CallLeadResponseModel.fromJson(json.decode(str));

String callLeadResponseModelToJson(CallLeadResponseModel data) => json.encode(data.toJson());

class CallLeadResponseModel {
  final bool success;
  final List<Customer> data;
  final int totalCount;

  CallLeadResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory CallLeadResponseModel.fromJson(Map<String, dynamic> json) => CallLeadResponseModel(
    success: json["success"],
    data: List<Customer>.from(json["data"].map((x) => Customer.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class Customer {
  final String leadId;
  final String customerName;

  Customer({
    required this.leadId,
    required this.customerName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    leadId: json["leadId"],
    customerName: json["customerName"],
  );

  Map<String, dynamic> toJson() => {
    "leadId": leadId,
    "customerName": customerName,
  };
}
