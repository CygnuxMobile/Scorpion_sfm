
import 'dart:convert';

EscalatedHistoryResponseModel escalatedHistoryResponseModelFromJson(String str) => EscalatedHistoryResponseModel.fromJson(json.decode(str));

String escalatedHistoryResponseModelToJson(EscalatedHistoryResponseModel data) => json.encode(data.toJson());

class EscalatedHistoryResponseModel {
  final bool success;
  final List<EscalatedHistoryDatum> escalatedHistoryData;
  final int totalCount;

  EscalatedHistoryResponseModel({
    required this.success,
    required this.escalatedHistoryData,
    required this.totalCount,
  });

  factory EscalatedHistoryResponseModel.fromJson(Map<String, dynamic> json) => EscalatedHistoryResponseModel(
    success: json["success"],
    escalatedHistoryData: List<EscalatedHistoryDatum>.from(json["data"].map((x) => EscalatedHistoryDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "escalatedHistoryData": List<dynamic>.from(escalatedHistoryData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class EscalatedHistoryDatum {
  final String complaintId;
  final String escalatedTo;
  final String escalatedEmail;
  final String escalatedDate;
  final String remark;
  final String createBy;
  final String createDate;

  EscalatedHistoryDatum({
    required this.complaintId,
    required this.escalatedTo,
    required this.escalatedEmail,
    required this.escalatedDate,
    required this.remark,
    required this.createBy,
    required this.createDate,
  });

  factory EscalatedHistoryDatum.fromJson(Map<String, dynamic> json) => EscalatedHistoryDatum(
    complaintId: json["complaintID"]??"",
    escalatedTo: json["escalatedTo"]??"",
    escalatedEmail: json["escalatedEmail"]??"",
    escalatedDate: json["escalatedDate"]??"",
    remark: json["remark"]??"",
    createBy: json["createBy"]??"",
    createDate: json["createDate"]??"",
  );

  Map<String, dynamic> toJson() => {
    "complaintID": complaintId,
    "escalatedTo": escalatedTo,
    "escalatedEmail": escalatedEmail,
    "escalatedDate": escalatedDate,
    "remark": remark,
    "createBy": createBy,
    "createDate": createDate,
  };
}
