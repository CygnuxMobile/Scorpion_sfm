import 'dart:convert';

AddLeadRequestModel addLeadRequestModelFromJson(String str) => AddLeadRequestModel.fromJson(json.decode(str));

String addLeadRequestModelToJson(AddLeadRequestModel data) => json.encode(data.toJson());

class AddLeadRequestModel {
  final String address;
  final String assignedToId;
  final String branchId;
  final int cityId;
  final String companyName;
  final String contactName;
  final String contactNo;
  final String designationId;
  final String email;
  final String industryTypeId;
  final bool isActive;
  final int leadCategoryId;
  final String leadDate;
  final String leadSourceId;
  final String regionId;
  final String serviceInterestedIDs;
  final String createdBy;

  AddLeadRequestModel({
    required this.address,
    required this.assignedToId,
    required this.branchId,
    required this.cityId,
    required this.companyName,
    required this.contactName,
    required this.contactNo,
    required this.designationId,
    required this.email,
    required this.industryTypeId,
    required this.isActive,
    required this.leadCategoryId,
    required this.leadDate,
    required this.leadSourceId,
    required this.regionId,
    required this.serviceInterestedIDs,
    required this.createdBy,
  });

  factory AddLeadRequestModel.fromJson(Map<String, dynamic> json) => AddLeadRequestModel(
        address: json["address"],
        assignedToId: json["assignedToId"],
        branchId: json["branchId"],
        cityId: json["cityId"],
        companyName: json["companyName"],
        contactName: json["contactName"],
        contactNo: json["contactNo"],
        designationId: json["designationId"],
        email: json["email"],
        industryTypeId: json["industryTypeId"],
        isActive: json["isActive"],
        leadCategoryId: json["leadCategoryId"],
        leadDate: json["leadDate"],
        leadSourceId: json["leadSourceId"],
        regionId: json["regionId"],
        serviceInterestedIDs: json["serviceInterestedIDs"],
        createdBy: json["CreatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "assignedToId": assignedToId,
        "branchId": branchId,
        "cityId": cityId,
        "companyName": companyName,
        "contactName": contactName,
        "contactNo": contactNo,
        "designationId": designationId,
        "email": email,
        "industryTypeId": industryTypeId,
        "isActive": isActive,
        "leadCategoryId": leadCategoryId,
        "leadDate": leadDate,
        "leadSourceId": leadSourceId,
        "regionId": regionId,
        "serviceInterestedIDs": serviceInterestedIDs,
        "createdBy": createdBy,
      };
}
