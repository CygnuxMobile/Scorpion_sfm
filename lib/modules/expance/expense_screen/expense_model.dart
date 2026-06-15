import 'dart:convert';

ExpenseResponseModel expenseResponseModelFromJson(String str) => ExpenseResponseModel.fromJson(json.decode(str));

String expenseModelResponseToJson(ExpenseResponseModel data) => json.encode(data.toJson());

class ExpenseResponseModel {
  final bool success;
  final List<ExpenseDatum> expenseData;
  final int totalCount;

  ExpenseResponseModel({
    required this.success,
    required this.expenseData,
    required this.totalCount,
  });

  factory ExpenseResponseModel.fromJson(Map<String, dynamic> json) => ExpenseResponseModel(
    success: json["success"],
    expenseData: List<ExpenseDatum>.from(json["data"].map((x) => ExpenseDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "ExpenseData": List<dynamic>.from(expenseData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class ExpenseDatum {
  final String expenseId;
  final bool expenseCreated;
  final bool isManager_AuditApproved;
  final String expenseCode;
  final String expenseDate;
  final num expenseRate;
  final num amount;
   String status;
  final int expStatus;
  final int totalCount;
  final String meetingId;
  final String attendeeCode;
  final String createdBy;
  final String leadId;
  final String companyName;
  final double meetingLat;
  final double meetingLng;
  final String checkIn;
  final String checkOut;
  final int distanceTravelled;
  final String requestId;
  final String requestDate;
  final String contactName;
  final String meetingDate;
  final String reqId;
  final String rtgsNo;
  final String isEdit;

  ExpenseDatum({
    required this.expenseId,
    required this.expenseCreated,
    required this.isManager_AuditApproved,
    required this.expenseCode,
    required this.attendeeCode,
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
    required this.expStatus,
    required this.checkOut,
    required this.distanceTravelled,
    required this.requestId,
    required this.requestDate,
    required this.contactName,
    required this.meetingDate,
    required this.reqId,
    required this.rtgsNo,
    required this.isEdit,
  });

  factory ExpenseDatum.fromJson(Map<String, dynamic> json) => ExpenseDatum(
    expenseId: json["expenseId"] ?? "",
    expenseCode: json["expenseCode"] ?? "",
    isManager_AuditApproved: json["isManager_AuditApproved"] ?? false,
    expenseDate: json["expenseDate"] ?? "",
    amount: json["amount"]??0,
    status: json["status"] ?? "",
    createdBy: json["createdBy"] ?? '',
    attendeeCode: json["attendeeCode"] ?? '',
    totalCount: json["totalCount"] ?? 0,
    meetingId: json["meetingId"] ?? "",
    leadId: json["leadId"]??"",
    companyName: json["companyName"]??"",
    meetingLat: json["meetingLat"]??0.0,
    meetingLng: json["meetingLng"]??0.0,
    checkIn: json["checkIn"]??"",
    checkOut: json["checkOut"]??"",
    expStatus : json["exp_Status"]??"",
    distanceTravelled: json["distanceTravelled"]??0,
    requestId: json["requestID"]??"",
    requestDate: json["requestDate"]??"",
    expenseCreated: json["expenseCreated"]??false,
    expenseRate: json["expenseRate"]??0,
    contactName: json["contactName"] ?? '',
    meetingDate: json["meetingDate"] ?? '',
    rtgsNo: json["rtgsNo"] ?? '',
    reqId: json["reqId"] ?? '',
    isEdit: json["isEdit"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "expenseId": expenseId,
    "expenseCreated": expenseCreated,
    "isManager_AuditApproved": isManager_AuditApproved,
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
    "exp_Status": expStatus,
    "meetingLng": meetingLng,
    "checkIn": checkIn,
    "checkOut": checkOut,
    "distanceTravelled": distanceTravelled,
    "requestID": requestId,
    "requestDate": requestDate,
  };
}
