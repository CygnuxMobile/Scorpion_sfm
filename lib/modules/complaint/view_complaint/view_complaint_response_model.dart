import 'dart:convert';

ViewComplaintResponseModel viewComplaintResponseModelFromJson(String str) => ViewComplaintResponseModel.fromJson(json.decode(str));

String viewComplaintResponseModelToJson(ViewComplaintResponseModel data) => json.encode(data.toJson());

class ViewComplaintResponseModel {
  final bool success;
  final ViewComplaintData viewComplaintData;
  final int totalCount;

  ViewComplaintResponseModel({
    required this.success,
    required this.viewComplaintData,
    required this.totalCount,
  });

  factory ViewComplaintResponseModel.fromJson(Map<String, dynamic> json) => ViewComplaintResponseModel(
    success: json["success"],
    viewComplaintData: ViewComplaintData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "viewComplaintData": viewComplaintData.toJson(),
    "totalCount": totalCount,
  };
}

class ViewComplaintData {
  final String complaintId;
  final String documentNo;
  final String edd;
  final String documentDate;
  final String origin;
  final String destination;
  final String customerName;
  final String compalaintDate;
  final String compaintStatus;
  final String resolutionDate;
  final String slaInHr;
  final String raisedBy;
  final String assignedTo;
  final bool isEscalated;
  final bool isClosed;
  final String ticketAddressTo;
  final String ticketSource;
  final String ticketDate;
  final String ticketType;
  final String ticketSubType;
  final String ticketPriority;
  final int source;
  final int type;
  final int subType;
  final int priority;
  final String description;
  final String customerEmail;
  final String document;
  final String escalationId;
  final String escalationTo;
  final String escalationDate;
  final String escalationHistory;
  final String escEmailId;
  final String updateDate;
  final String updateRemark;
  final String updateHistory;
  final String closeBy;
  final String closeDate;
  final int totalCount;

  ViewComplaintData({
    required this.complaintId,
    required this.documentNo,
    required this.edd,
    required this.documentDate,
    required this.origin,
    required this.destination,
    required this.customerName,
    required this.compalaintDate,
    required this.compaintStatus,
    required this.resolutionDate,
    required this.slaInHr,
    required this.raisedBy,
    required this.assignedTo,
    required this.isEscalated,
    required this.isClosed,
    required this.ticketAddressTo,
    required this.ticketSource,
    required this.ticketDate,
    required this.ticketType,
    required this.ticketSubType,
    required this.ticketPriority,
    required this.source,
    required this.type,
    required this.subType,
    required this.priority,
    required this.description,
    required this.customerEmail,
    required this.document,
    required this.escalationId,
    required this.escalationTo,
    required this.escalationDate,
    required this.escalationHistory,
    required this.escEmailId,
    required this.updateDate,
    required this.updateRemark,
    required this.updateHistory,
    required this.closeBy,
    required this.closeDate,
    required this.totalCount,
  });

  factory ViewComplaintData.fromJson(Map<String, dynamic> json) => ViewComplaintData(
    complaintId: json["complaintID"]??"",
    documentNo: json["documentNo"]??"",
    edd: json["edd"]??"",
    documentDate: json["documentDate"]??"",
    origin: json["origin"]??"",
    destination: json["destination"]??"",
    customerName: json["customerName"]??"",
    compalaintDate: json["compalaintDate"]??"",
    compaintStatus: json["compaintStatus"]??"",
    resolutionDate: json["resolutionDate"]??"",
    slaInHr: json["slaInHr"]??"",
    raisedBy: json["raisedBy"]??"",
    assignedTo: json["assignedTo"]??"",
    isEscalated: json["isEscalated"]??false,
    isClosed: json["isClosed"]??false,
    ticketAddressTo: json["ticketAddressTo"]??"",
    ticketSource: json["ticketSource"]??"",
    ticketDate: json["ticketDate"]??"",
    ticketType: json["ticketType"]??"",
    ticketSubType: json["ticketSubType"]??"",
    ticketPriority: json["ticketPriority"]??"",
    source: json["source"]??0,
    type: json["type"]??0,
    subType: json["subType"]??0,
    priority: json["priority"]??0,
    description: json["description"]??"",
    customerEmail: json["customerEmail"]??"",
    document: json["document"]??"",
    escalationId: json["escalationId"]??"",
    escalationTo: json["escalationTo"]??"",
    escalationDate: json["escalationDate"]??"",
    escalationHistory: json["escalationHistory"]??"",
    escEmailId: json["escEmailId"]??"",
    updateDate: json["updateDate"]??"",
    updateRemark: json["updateRemark"]??"",
    updateHistory: json["updateHistory"]??"",
    closeBy: json["closeBy"]??"",
    closeDate: json["closeDate"]??"",
    totalCount: json["totalCount"]??0,
  );

  Map<String, dynamic> toJson() => {
    "complaintID": complaintId,
    "documentNo": documentNo,
    "edd": edd,
    "documentDate": documentDate,
    "origin": origin,
    "destination": destination,
    "customerName": customerName,
    "compalaintDate": compalaintDate,
    "compaintStatus": compaintStatus,
    "resolutionDate": resolutionDate,
    "slaInHr": slaInHr,
    "raisedBy": raisedBy,
    "assignedTo": assignedTo,
    "isEscalated": isEscalated,
    "isClosed": isClosed,
    "ticketAddressTo": ticketAddressTo,
    "ticketSource": ticketSource,
    "ticketDate": ticketDate,
    "ticketType": ticketType,
    "ticketSubType": ticketSubType,
    "ticketPriority": ticketPriority,
    "source": source,
    "type": type,
    "subType": subType,
    "priority": priority,
    "description": description,
    "customerEmail": customerEmail,
    "document": document,
    "escalationId": escalationId,
    "escalationTo": escalationTo,
    "escalationDate": escalationDate,
    "escalationHistory": escalationHistory,
    "escEmailId": escEmailId,
    "updateDate": updateDate,
    "updateRemark": updateRemark,
    "updateHistory": updateHistory,
    "closeBy": closeBy,
    "closeDate": closeDate,
    "totalCount": totalCount,
  };
}
