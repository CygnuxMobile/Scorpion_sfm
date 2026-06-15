import 'dart:convert';

UpdateHistoryResponseModel updateHistoryResponseModelFromJson(String str) => UpdateHistoryResponseModel.fromJson(json.decode(str));

String updateHistoryResponseModelToJson(UpdateHistoryResponseModel data) => json.encode(data.toJson());

class UpdateHistoryResponseModel {
  final bool success;
  final List<UpdateHistoryDatum> updateHistoryData;
  final int totalCount;

  UpdateHistoryResponseModel({
    required this.success,
    required this.updateHistoryData,
    required this.totalCount,
  });

  factory UpdateHistoryResponseModel.fromJson(Map<String, dynamic> json) => UpdateHistoryResponseModel(
    success: json["success"],
    updateHistoryData: List<UpdateHistoryDatum>.from(json["data"].map((x) => UpdateHistoryDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "updateHistoryData": List<dynamic>.from(updateHistoryData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class UpdateHistoryDatum {
  final String complaintId;
  final String documentNo;
  final String complaintDate;
  final String ticketSource;
  final String ticketType;
  final String ticketSubType;
  final String ticketPriority;
  final String ticketDescription;
  final String customerName;
  final String ticketCreateBy;
  final String updateBy;
  final String updateRemark;
  final String assignedTo;
  final String complaintStatus;
  final String ticketAddressTo;
  final String updateDate;
  final String remark;

  UpdateHistoryDatum({
    required this.complaintId,
    required this.documentNo,
    required this.complaintDate,
    required this.ticketSource,
    required this.ticketType,
    required this.ticketSubType,
    required this.ticketPriority,
    required this.ticketDescription,
    required this.customerName,
    required this.ticketCreateBy,
    required this.updateBy,
    required this.updateRemark,
    required this.assignedTo,
    required this.complaintStatus,
    required this.ticketAddressTo,
    required this.updateDate,
    required this.remark,
  });

  factory UpdateHistoryDatum.fromJson(Map<String, dynamic> json) => UpdateHistoryDatum(
    complaintId: json["complaintID"]??"",
    documentNo: json["documentNo"]??"",
    complaintDate: json["complaintDate"]??"",
    ticketSource: json["ticketSource"]??"",
    ticketType: json["ticketType"]??"",
    ticketSubType: json["ticketSubType"]??"",
    ticketPriority: json["ticketPriority"]??"",
    ticketDescription: json["ticketDescription"]??"",
    customerName: json["customerName"]??"",
    ticketCreateBy: json["ticketCreateBy"]??"",
    updateBy: json["updateBy"]??"",
    updateRemark: json["updateRemark"]??"",
    assignedTo: json["assignedTo"]??"",
    complaintStatus: json["complaintStatus"]??"",
    ticketAddressTo: json["ticketAddressTo"]??"",
    updateDate: json["updateDate"]??"",
    remark: json["remark"]??"",
  );

  Map<String, dynamic> toJson() => {
    "complaintID": complaintId,
    "documentNo": documentNo,
    "complaintDate": complaintDate,
    "ticketSource": ticketSource,
    "ticketType": ticketType,
    "ticketSubType": ticketSubType,
    "ticketPriority": ticketPriority,
    "ticketDescription": ticketDescription,
    "customerName": customerName,
    "ticketCreateBy": ticketCreateBy,
    "updateBy": updateBy,
    "updateRemark": updateRemark,
    "assignedTo": assignedTo,
    "complaintStatus": complaintStatus,
    "ticketAddressTo": ticketAddressTo,
    "updateDate": updateDate,
    "remark": remark,
  };
}
