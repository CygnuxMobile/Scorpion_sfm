import 'dart:convert';

ViewExpenseResponseModel viewExpenseResponseModelFromJson(String str) => ViewExpenseResponseModel.fromJson(json.decode(str));

String viewExpenseResponseModelToJson(ViewExpenseResponseModel data) => json.encode(data.toJson());

class ViewExpenseResponseModel {
  final bool success;
  final ViewExpenseData viewExpenseData;
  final num totalCount;

  ViewExpenseResponseModel({
    required this.success,
    required this.viewExpenseData,
    required this.totalCount,
  });

  factory ViewExpenseResponseModel.fromJson(Map<String, dynamic> json) => ViewExpenseResponseModel(
    success: json["success"],
    viewExpenseData: ViewExpenseData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "viewExpenseData": viewExpenseData.toJson(),
    "totalCount": totalCount,
  };
}

class ViewExpenseData {
  final String punchedInLocation;
  final String checkedInLocation;
  final num distanceInKm;
  final String supportingDocument;
  final String remarks;
  final String transportMode;
  final String transportModeId;
  final String isEdit;
  final bool adminApproved;
  final bool managerApproved;
  final String managerRemark;
  final String auditRemark;
  final String expenseAddedBy;
  final String expenseEditedBy;
  final String expensEditDate;
  final String approveByManagerName;
  final String approvedManagerDate;
  final String approvedByAuditorName;
  final String approvedByAuditDate;
  final String expenseId;
  final bool expenseCreated;
  final String expenseCode;
  final String expenseDate;
  final num expenseRate;
  final num amount;
  final String status;
  final num totalCount;
  final String meetingId;
  final String createdBy;
  final String leadId;
  final String companyName;
  final num meetingLat;
  final num meetingLng;
  final String checkIn;
  final String checkOut;
  final num distanceTravelled;
  final String requestId;
  final String requestDate;
  final bool isApproved;
  final String approvedBy;
  final String approvedDate;
  final bool isAuditApproved;
  final String auditedBy;
  final String auditDate;
  final String auditRemarks;
  final String expenseAddedDate;
  final String expenseAddedTime;
  final String expenseModifiedDate;
  final String expenseModifiedTime;

  ViewExpenseData({
    required this.punchedInLocation,
    required this.checkedInLocation,
    required this.distanceInKm,
    required this.supportingDocument,
    required this.remarks,
    required this.transportMode,
    required this.transportModeId,
    required this.isEdit,
    required this.adminApproved,
    required this.managerApproved,
    required this.managerRemark,
    required this.auditRemark,
    required this.expenseAddedBy,
    required this.expenseEditedBy,
    required this.expensEditDate,
    required this.approveByManagerName,
    required this.approvedManagerDate,
    required this.approvedByAuditorName,
    required this.approvedByAuditDate,
    required this.expenseId,
    required this.expenseCreated,
    required this.expenseCode,
    required this.expenseDate,
    required this.expenseRate,
    required this.amount,
    required this.status,
    required this.totalCount,
    required this.meetingId,
    required this.createdBy,
    required this.leadId,
    required this.companyName,
    required this.meetingLat,
    required this.meetingLng,
    required this.checkIn,
    required this.checkOut,
    required this.distanceTravelled,
    required this.requestId,
    required this.requestDate,
    required this.isApproved,
    required this.approvedBy,
    required this.approvedDate,
    required this.isAuditApproved,
    required this.auditedBy,
    required this.auditDate,
    required this.auditRemarks,
    required this.expenseAddedDate,
    required this.expenseAddedTime,
    required this.expenseModifiedDate,
    required this.expenseModifiedTime,
  });

  factory ViewExpenseData.fromJson(Map<String, dynamic> json) => ViewExpenseData(
    punchedInLocation: json["punchedInLocation"]??"",
    checkedInLocation: json["checkedInLocation"]??"",
    distanceInKm: json["distanceInKm"]??0,
    supportingDocument: json["supportingDocument"]??"",
    remarks: json["remarks"]??"",
    transportMode: json["transportMode"]??"",
    transportModeId: json["transportModeId"]??"",
    isEdit: json["isEdit"]??"",
    adminApproved: json["adminApproved"]??false,
    managerApproved: json["managerApproved"]??false,
    managerRemark: json["managerRemark"]??"",
    auditRemark: json["auditRemark"]??"",
    expenseAddedBy: json["expenseAddedBy"]??"",
    expenseEditedBy: json["expenseEditedBy"]??"",
    expensEditDate: json["expensEditDate"]??"",
    approveByManagerName: json["approveByManagerName"]??"",
    approvedManagerDate: json["approvedManagerDate"]??"",
    approvedByAuditorName: json["approvedByAuditorName"]??"",
    approvedByAuditDate: json["approvedByAuditDate"]??"",
    expenseId: json["expenseId"]??"",
    expenseCreated: json["expenseCreated"]??false,
    expenseCode: json["expenseCode"]??"",
    expenseDate: json["expenseDate"]??"",
    expenseRate: json["expenseRate"]??0,
    amount: json["amount"]??0,
    status: json["status"]??"",
    totalCount: json["totalCount"]??0,
    meetingId: json["meetingId"]??"",
    createdBy: json["createdBy"]??"",
    leadId: json["leadId"]??"",
    companyName: json["companyName"]??"",
    meetingLat: json["meetingLat"]??0,
    meetingLng: json["meetingLng"]??0,
    checkIn: json["checkIn"]??"",
    checkOut: json["checkOut"]??"",
    distanceTravelled: json["distanceTravelled"]??0,
    requestId: json["requestID"]??"",
    requestDate: json["requestDate"]??"",
    isApproved: json["isApproved"]??false,
    approvedBy: json["approvedBy"]??"",
    approvedDate: json["approvedDate"]??"",
    isAuditApproved: json["isAuditApproved"]??false,
    auditedBy: json["auditedBy"]??"",
    auditDate: json["auditDate"]??"",
    auditRemarks: json["auditRemarks"]??"",
    expenseAddedDate: json["expenseAddedDate"]??"",
    expenseAddedTime: json["expenseAddedTime"]??"",
    expenseModifiedDate: json["expenseModifiedDate"]??"",
    expenseModifiedTime: json["expenseModifiedTime"]??"",
  );

  Map<String, dynamic> toJson() => {
    "punchedInLocation": punchedInLocation,
    "checkedInLocation": checkedInLocation,
    "distanceInKm": distanceInKm,
    "supportingDocument": supportingDocument,
    "remarks": remarks,
    "transportMode": transportMode,
    "transportModeId": transportModeId,
    "isEdit": isEdit,
    "adminApproved": adminApproved,
    "managerApproved": managerApproved,
    "managerRemark": managerRemark,
    "auditRemark": auditRemark,
    "expenseAddedBy": expenseAddedBy,
    "expenseEditedBy": expenseEditedBy,
    "expensEditDate": expensEditDate,
    "approveByManagerName": approveByManagerName,
    "approvedManagerDate": approvedManagerDate,
    "approvedByAuditorName": approvedByAuditorName,
    "approvedByAuditDate": approvedByAuditDate,
    "expenseId": expenseId,
    "expenseCreated": expenseCreated,
    "expenseCode": expenseCode,
    "expenseDate": expenseDate,
    "expenseRate": expenseRate,
    "amount": amount,
    "status": status,
    "totalCount": totalCount,
    "meetingId": meetingId,
    "createdBy": createdBy,
    "leadId": leadId,
    "companyName": companyName,
    "meetingLat": meetingLat,
    "meetingLng": meetingLng,
    "checkIn": checkIn,
    "checkOut": checkOut,
    "distanceTravelled": distanceTravelled,
    "requestID": requestId,
    "requestDate": requestDate,
    "isApproved": isApproved,
    "approvedBy": approvedBy,
    "approvedDate": approvedDate,
    "isAuditApproved": isAuditApproved,
    "auditedBy": auditedBy,
    "auditDate": auditDate,
    "auditRemarks": auditRemarks,
    "expenseAddedDate": expenseAddedDate,
    "expenseAddedTime": expenseAddedTime,
    "expenseModifiedDate": expenseModifiedDate,
    "expenseModifiedTime": expenseModifiedTime,
  };
}