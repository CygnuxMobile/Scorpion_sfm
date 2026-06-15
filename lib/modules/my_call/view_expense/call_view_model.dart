import 'dart:convert';

CallViewResponseModel callViewResponseModelFromJson(String str) => CallViewResponseModel.fromJson(json.decode(str));

String callViewResponseModelToJson(CallViewResponseModel data) => json.encode(data.toJson());

class CallViewResponseModel {
  final bool success;
  final CallViewData callViewData;
  final int totalCount;

  CallViewResponseModel({
    required this.success,
    required this.callViewData,
    required this.totalCount,
  });

  factory CallViewResponseModel.fromJson(Map<String, dynamic> json) => CallViewResponseModel(
    success: json["success"],
    callViewData: CallViewData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "CallViewData": callViewData.toJson(),
    "totalCount": totalCount,
  };
}

class CallViewData {
  final String leadId;
  final String callPurpose;
  final String purpose;
  final String remarks;
  final String attendees;
  final String callId;
  final int callCategoryId;
  final String callCategoryName;
  final String callDate;
  final String customerName;
  final String startTime;
  final String endTime;
  final String callStatus;
  final String createdBy;
  final String modifiedBy;
  final String createdDate;
  final String modifiedDate;

  CallViewData({
    required this.leadId,
    required this.callPurpose,
    required this.purpose,
    required this.remarks,
    required this.attendees,
    required this.callId,
    required this.callCategoryId,
    required this.callCategoryName,
    required this.callDate,
    required this.customerName,
    required this.startTime,
    required this.endTime,
    required this.callStatus,
    required this.createdBy,
    required this.modifiedBy,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory CallViewData.fromJson(Map<String, dynamic> json) => CallViewData(
    leadId: json["leadId"]??"",
    callPurpose: json["callPurpose"]??"",
    purpose: json["purpose"] ?? '',
    remarks: json["remarks"]??"",
    attendees: json["attendees"]??"",
    callId: json["callId"]??"",
    callCategoryId: json["callCategoryId"]??0,
    callCategoryName: json["callCategoryName"]??"",
    callDate: json["callDate"]??"",
    customerName: json["customerName"]??"",
    startTime: json["startTime"]??"",
    endTime: json["endTime"]??"",
    callStatus: json["callStatus"]??"",
    createdBy: json["createdBy"]??"",
    modifiedBy: json["modifiedBy"]??"",
    createdDate: json["createdDate"]??"",
    modifiedDate: json["modifiedDate"]??"",
  );

  Map<String, dynamic> toJson() => {
    "leadId": leadId,
    "callPurpose": callPurpose,
    "remarks": remarks,
    "attendees": attendees,
    "callId": callId,
    "callCategoryId": callCategoryId,
    "callCategoryName": callCategoryName,
    "callDate": callDate,
    "customerName": customerName,
    "startTime": startTime,
    "endTime": endTime,
    "callStatus": callStatus,
    "createdBy": createdBy,
    "modifiedBy": modifiedBy,
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
  };
}
