
import 'dart:convert';

LeadModel leadModelFromJson(String str) => LeadModel.fromJson(json.decode(str));

String leadModelToJson(LeadModel data) => json.encode(data.toJson());

class LeadModel {
  final bool success;
  final List<Datum> data;
  final int totalCount;

  LeadModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) => LeadModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class Datum {
  final String leadId;
  final String leadCategory;
  final int leadCategoryId;
  final String companyName;
  final String leadDate;
  final String assignedTo;
  final String contactName;
  final String email;
  final String contactNo;
  final String address;
  final bool isActive;
  final bool leadCreated;
  final int totalCount;

  Datum({
    required this.leadId,
    required this.leadCategory,
    required this.leadCategoryId,
    required this.companyName,
    required this.leadDate,
    required this.assignedTo,
    required this.contactName,
    required this.email,
    required this.contactNo,
    required this.address,
    required this.isActive,
    required this.leadCreated,
    required this.totalCount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    leadId: json["leadId"] ?? "",
    leadCategory: json["leadCategory"] ?? "",
    leadCategoryId: json["leadCategoryId"] ?? 0,
    companyName: json["companyName"] ?? "",
    leadDate: json["leadDate"] ?? "",
    assignedTo: json["assignedTo"] ?? "",
    contactName: json["contactName"] ?? "",
    email: json["email"] ?? "",
    contactNo: json["contactNo"] ?? "",
    address: json["address"] ?? "",
    isActive: json["isActive"] ?? true,
    leadCreated: json["leadCreated"] ?? true,
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "leadId": leadId,
    "leadCategory": leadCategory,
    "leadCategoryId": leadCategoryId,
    "companyName": companyName,
    "leadDate": leadDate,
    "assignedTo": assignedTo,
    "contactName": contactName,
    "email": email,
    "contactNo": contactNo,
    "address": address,
    "isActive": isActive,
    "totalCount": totalCount,
  };
}
