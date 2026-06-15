import 'dart:convert';

EditExpenseResponseModel editExpenseResponseModelFromJson(String str) => EditExpenseResponseModel.fromJson(json.decode(str));

String editExpenseResponseModelToJson(EditExpenseResponseModel data) => json.encode(data.toJson());

class EditExpenseResponseModel {
  final bool success;
  final EditExpensedData editExpensedData;
  final int totalCount;

  EditExpenseResponseModel({
    required this.success,
    required this.editExpensedData,
    required this.totalCount,
  });

  factory EditExpenseResponseModel.fromJson(Map<String, dynamic> json) => EditExpenseResponseModel(
    success: json["success"],
    editExpensedData: EditExpensedData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "EditExpensedData": editExpensedData.toJson(),
    "totalCount": totalCount,
  };
}

class EditExpensedData {
  final String punchedInLocation;
  final String checkedInLocation;
  final num distanceInKm;
  final String supportingDocument;
  final String remarks;
  final String transportMode;
  final String transportModeId;
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
  final String attendeeCode;
  final double meetingLat;
  final double meetingLng;
  final String checkIn;
  final String checkOut;
  final num distanceTravelled;
  final String requestId;
  final String requestDate;

  EditExpensedData({
    required this.punchedInLocation,
    required this.checkedInLocation,
    required this.distanceInKm,
    required this.supportingDocument,
    required this.remarks,
    required this.transportMode,
    required this.transportModeId,
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
    required this.attendeeCode,
    required this.meetingLng,
    required this.checkIn,
    required this.checkOut,
    required this.distanceTravelled,
    required this.requestId,
    required this.requestDate,
  });

  factory EditExpensedData.fromJson(Map<String, dynamic> json) => EditExpensedData(
    punchedInLocation: json["punchedInLocation"],
    checkedInLocation: json["checkedInLocation"],
    distanceInKm: json["distanceInKm"],
    supportingDocument: json["supportingDocument"],
    remarks: json["remarks"],
    transportMode: json["transportMode"],
    transportModeId: json["transportModeId"],
    expenseId: json["expenseId"],
    attendeeCode: json["attendeeCode"]??"",
    expenseCreated: json["expenseCreated"],
    expenseCode: json["expenseCode"],
    expenseDate: json["expenseDate"],
    expenseRate: json["expenseRate"],
    amount: json["amount"],
    status: json["status"],
    totalCount: json["totalCount"],
    meetingId: json["meetingId"],
    createdBy: json["createdBy"],
    leadId: json["leadId"],
    companyName: json["companyName"],
    meetingLat: json["meetingLat"]?.toDouble(),
    meetingLng: json["meetingLng"]?.toDouble(),
    checkIn: json["checkIn"],
    checkOut: json["checkOut"],
    distanceTravelled: json["distanceTravelled"],
    requestId: json["requestID"],
    requestDate: json["requestDate"],
  );

  Map<String, dynamic> toJson() => {
    "punchedInLocation": punchedInLocation,
    "checkedInLocation": checkedInLocation,
    "distanceInKm": distanceInKm,
    "supportingDocument": supportingDocument,
    "remarks": remarks,
    "transportMode": transportMode,
    "transportModeId": transportModeId,
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
  };
}
