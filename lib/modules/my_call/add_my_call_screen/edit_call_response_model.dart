import 'dart:convert';

EditCallResponseModel editCallResponseModelFromJson(String str) => EditCallResponseModel.fromJson(json.decode(str));

String editCallResponseModelToJson(EditCallResponseModel data) => json.encode(data.toJson());

class EditCallResponseModel {
  final bool success;
  final EditData data;
  final int totalCount;

  EditCallResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory EditCallResponseModel.fromJson(Map<String, dynamic> json) => EditCallResponseModel(
        success: json["success"],
        data: EditData.fromJson(json["data"]),
        totalCount: json["totalCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "totalCount": totalCount,
      };
}

class EditData {
  final String leadId;
  final String callPurpose;
  final String remarks;
  final String attendees;
  final int callStatusId;
  final String purpose;
  final String callMOM;
  final String attendeeNames;
  final String callId;
  final int callCategoryId;
  final String callCategoryName;
  final String callDate;
  final String customerName;
  final String startTime;
  final String endTime;
  final String callStatus;
  final String createdBy;
  final DateTime createdDate;

  EditData({
    required this.leadId,
    required this.callPurpose,
    required this.remarks,
    required this.attendees,
    required this.callStatusId,
    required this.purpose,
    required this.callMOM,
    required this.attendeeNames,
    required this.callId,
    required this.callCategoryId,
    required this.callCategoryName,
    required this.callDate,
    required this.customerName,
    required this.startTime,
    required this.endTime,
    required this.callStatus,
    required this.createdBy,
    required this.createdDate,
  });

  factory EditData.fromJson(Map<String, dynamic> json) => EditData(
        leadId: json["leadId"] ?? "",
        callPurpose: json["callPurpose"] ?? "",
        remarks: json["remarks"] ?? "",
        attendees: json["attendees"] ?? "",
        callStatusId: json["callStatusId"] ?? 0,
        purpose: json["purpose"] ?? "",
        callMOM: json["callMOM"] ?? "",
        attendeeNames: json["attendeeNames"] ?? "",
        callId: json["callId"] ?? "",
        callCategoryId: json["callCategoryId"] ?? 0,
        callCategoryName: json["callCategoryName"] ?? "",
        callDate: json["callDate"] ?? "",
        customerName: json["customerName"] ?? "",
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        callStatus: json["callStatus"] ?? "",
        createdBy: json["createdBy"] ?? "",
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "leadId": leadId,
        "callPurpose": callPurpose,
        "remarks": remarks,
        "attendees": attendees,
        "callStatusId": callStatusId,
        "purpose": purpose,
        "callMOM": callMOM,
        "attendeeNames": attendeeNames,
        "callId": callId,
        "callCategoryId": callCategoryId,
        "callCategoryName": callCategoryName,
        "callDate": callDate,
        "customerName": customerName,
        "startTime": startTime,
        "endTime": endTime,
        "callStatus": callStatus,
        "createdBy": createdBy,
        "createdDate": createdDate.toIso8601String(),
      };
}
