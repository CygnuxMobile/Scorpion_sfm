import 'dart:convert';

CustomerResponse customerResponseFromJson(String str) =>
    CustomerResponse.fromJson(json.decode(str));

String customerResponseToJson(CustomerResponse data) =>
    json.encode(data.toJson());

class CustomerResponse {
  final bool success;
  final List<CustomerList> customerList;
  final int totalCount;

  CustomerResponse({
    required this.success,
    required this.customerList,
    required this.totalCount,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      CustomerResponse(
        success: json["success"] ?? false,
        customerList: json["data"] != null
            ? List<CustomerList>.from(
            json["data"].map((x) => CustomerList.fromJson(x)))
            : [],
        totalCount: json["totalCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(customerList.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class CustomerList {
  final String tenantId;
  final String customerCode;
  final String customerName;
  final String contractId;
  final String contactName;
  final String address;
  final String contactNo;
  final String email;
  final String startDate;
  final String endDate;
  final num salesMonth;
  final num salesYear;
  final num oSonDate;
  final num totalCount;

  CustomerList({
    required this.tenantId,
    required this.customerCode,
    required this.customerName,
    required this.contractId,
    required this.contactName,
    required this.address,
    required this.contactNo,
    required this.email,
    required this.startDate,
    required this.endDate,
    required this.salesMonth,
    required this.salesYear,
    required this.oSonDate,
    required this.totalCount,
  });


  static num parseNum(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0;
    }
  }

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
    tenantId: json["tenantId"] ?? '',
    customerCode: json["customerCode"] ?? '',
    customerName: json["customerName"] ?? '',
    contactName: json["contactName"]??"",
    address: json["address"]??"",
    contactNo: json["contactNo"]??"",
    email: json["email"]??"",
    contractId: json["contractId"] ?? '',
    startDate: json["startDate"] ?? '',
    endDate: json["endDate"] ?? '',
    salesMonth: parseNum(json["salesMonth"]),
    salesYear: parseNum(json["salesYear"]),
    oSonDate: parseNum(json["oSonDate"]),
    totalCount: parseNum(json["totalCount"]),
  );

  Map<String, dynamic> toJson() => {
    "tenantId": tenantId,
    "customerCode": customerCode,
    "customerName": customerName,
    "contractId": contractId,
    "contactName": contactName,
    "address": address,
    "contactNo": contactNo,
    "email": email,
    "startDate": startDate,
    "endDate": endDate,
    "salesMonth": salesMonth,
    "salesYear": salesYear,
    "oSonDate": oSonDate,
    "totalCount": totalCount,
  };
}
