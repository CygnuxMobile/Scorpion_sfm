import 'dart:convert';

GetCustomerResponseModel getCustomerResponseModelFromJson(String str) => GetCustomerResponseModel.fromJson(json.decode(str));

String getCustomerResponseModelToJson(GetCustomerResponseModel data) => json.encode(data.toJson());

class GetCustomerResponseModel {
  final bool success;
  final List<CustomerData> data;

  GetCustomerResponseModel({required this.success, required this.data});

  factory GetCustomerResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCustomerResponseModel(success: json["success"], data: List<CustomerData>.from(json["data"].map((x) => CustomerData.fromJson(x))));

  Map<String, dynamic> toJson() => {"success": success, "data": List<dynamic>.from(data.map((x) => x.toJson()))};
}

class CustomerData {
  final String? tenantId;
  final String customerCode;
  final String customerName;
  final String? contractId;
  final String? startDate;
  final String? endDate;
  final int? salesMonth;
  final int? salesYear;
  final int? oSonDate;

  CustomerData({
    this.tenantId,
    required this.customerCode,
    required this.customerName,
    this.contractId,
    this.startDate,
    this.endDate,
    this.salesMonth,
    this.salesYear,
    this.oSonDate,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
    tenantId: json["tenantId"],
    customerCode: json["customerCode"],
    customerName: json["customerName"],
    contractId: json["contractId"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    salesMonth: json["salesMonth"],
    salesYear: json["salesYear"],
    oSonDate: json["oSonDate"],
  );

  Map<String, dynamic> toJson() => {
    "tenantId": tenantId,
    "customerCode": customerCode,
    "customerName": customerName,
    "contractId": contractId,
    "startDate": startDate,
    "endDate": endDate,
    "salesMonth": salesMonth,
    "salesYear": salesYear,
    "oSonDate": oSonDate,
  };
}
