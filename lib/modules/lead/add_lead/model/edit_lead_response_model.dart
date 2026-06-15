// To parse this JSON data, do
//
//     final editLeadResponseModel = editLeadResponseModelFromJson(jsonString);

import 'dart:convert';

EditLeadResponseModel editLeadResponseModelFromJson(String str) => EditLeadResponseModel.fromJson(json.decode(str));

String editLeadResponseModelToJson(EditLeadResponseModel data) => json.encode(data.toJson());

class EditLeadResponseModel {
  final bool success;
  final Data data;
  final int totalCount;

  EditLeadResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory EditLeadResponseModel.fromJson(Map<String, dynamic> json) => EditLeadResponseModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "totalCount": totalCount,
      };
}

class Data {
  final int cityId;
  final String branchId;
  final String regionId;
  final String designationId;
  final String leadSourceId;
  final String leadSource;
  final String assignedToId;
  final String industryTypeId;
  final String region;
  final String branch;
  final String designation;
  final String industryType;
  final String modifiedBy;
  final String city;
  final String serviceInterestedNames;
  final String serviceInteresteds;
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

  Data({
    required this.cityId,
    required this.branchId,
    required this.regionId,
    required this.designationId,
    required this.leadSourceId,
    required this.leadSource,
    required this.assignedToId,
    required this.industryTypeId,
    required this.region,
    required this.branch,
    required this.designation,
    required this.industryType,
    required this.modifiedBy,
    required this.city,
    required this.serviceInterestedNames,
    required this.serviceInteresteds,
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cityId: json["cityId"] ?? 0,
        branchId: json["branchId"] ?? "",
        regionId: json["regionId"] ?? "",
        designationId: json["designationId"] ?? "",
        leadSourceId: json["leadSourceId"] ?? "",
        leadSource: json["leadSource"] ?? "",
        assignedToId: json["assignedToId"] ?? "",
        industryTypeId: json["industryTypeId"] ?? "",
        region: json["region"] ?? "",
        branch: json["branch"] ?? "",
        designation: json["designation"] ?? "",
        industryType: json["industryType"] ?? "",
        modifiedBy: json["modifiedBy"] ?? "",
        city: json["city"] ?? "",
        serviceInterestedNames: json["serviceInterestedNames"] ?? "",
        serviceInteresteds: json["serviceInteresteds"] ?? "",
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
      );

  Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "branchId": branchId,
        "regionId": regionId,
        "designationId": designationId,
        "leadSourceId": leadSourceId,
        "leadSource": leadSource,
        "assignedToId": assignedToId,
        "industryTypeId": industryTypeId,
        "region": region,
        "branch": branch,
        "designation": designation,
        "industryType": industryType,
        "modifiedBy": modifiedBy,
        "city": city,
        "serviceInterestedNames": serviceInterestedNames,
        "serviceInteresteds": serviceInteresteds,
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
      };
}
