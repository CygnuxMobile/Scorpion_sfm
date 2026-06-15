import 'dart:convert';

CallResponseModel callResponseModelFromJson(String str) => CallResponseModel.fromJson(json.decode(str));

String callResponseModelToJson(CallResponseModel data) => json.encode(data.toJson());

class CallResponseModel {
  final bool success;
  final List<CallDatum> callData;
  final int totalCount;

  CallResponseModel({
    required this.success,
    required this.callData,
    required this.totalCount,
  });

  factory CallResponseModel.fromJson(Map<String, dynamic> json) => CallResponseModel(
    success: json["success"],
    callData: List<CallDatum>.from(json["data"].map((x) => CallDatum.fromJson(x))),
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "CallData": List<dynamic>.from(callData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class CallDatum {
  final String callId;
  final int callCategoryId;
  final String callCategoryName;
  final String callDate;
  final String customerName;
  final String startTime;
  final String endTime;
  final String callStatus;
  final int totalCount;
  final String createdBy;
  final String createdDate;

  CallDatum({
    required this.callId,
    required this.callCategoryId,
    required this.callCategoryName,
    required this.callDate,
    required this.customerName,
    required this.startTime,
    required this.endTime,
    required this.callStatus,
    required this.totalCount,
    required this.createdBy,
    required this.createdDate,
  });


  factory CallDatum.fromJson(Map<String, dynamic> json) => CallDatum(
    callId: json["callId"]??"",
    callCategoryId: json["callCategoryId"]??0,
    callCategoryName: json["callCategoryName"]??"",
    callDate: json["callDate"]??"",
    customerName: json["customerName"]??"",
    startTime: json["startTime"]??"",
    endTime: json["endTime"]??"",
    callStatus: json["callStatus"]??"",
    totalCount: json["totalCount"]??0,
    createdBy: json["createdBy"]??"",
    createdDate: json["createdDate"]??"",
  );

  Map<String, dynamic> toJson() => {
    "callId": callId,
    "callCategoryId": callCategoryId,
    "callCategoryName": callCategoryName,
    "callDate": callDate,
    "customerName": customerName,
    "startTime": startTime,
    "endTime": endTime,
    "callStatus": callStatus,
    "totalCount": totalCount,
    "createdBy": createdBy,
    "createdDate": createdDate,
  };
}
