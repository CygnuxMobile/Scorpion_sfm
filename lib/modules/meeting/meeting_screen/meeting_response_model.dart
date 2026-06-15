import 'dart:convert';

import 'package:get/get.dart';

enum AttendanceStatus { none, checkIn, checkOut, completed }

MeetingResponseModel meetingResponseModelFromJson(String str) => MeetingResponseModel.fromJson(json.decode(str));

String meetingResponseModelToJson(MeetingResponseModel data) => json.encode(data.toJson());

class MeetingResponseModel {
  final bool success;
  final List<MeetingDatum> meetingData;
  final int totalCount;

  MeetingResponseModel({
    required this.success,
    required this.meetingData,
    required this.totalCount,
  });

  factory MeetingResponseModel.fromJson(Map<String, dynamic> json) => MeetingResponseModel(
        success: json["success"],
        meetingData: List<MeetingDatum>.from(json["data"].map((x) => MeetingDatum.fromJson(x))),
        totalCount: json["totalCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "meetingData": List<dynamic>.from(meetingData.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class MeetingDatum {
  final String leadId;
  final String meetingId;
  final String customerName;
  final String meetingDate;
  final String startTime;
  final String endTime;
  final num taTinHrs;
  final String meetingStatus;
  final String meetingMom;
  final num totalCount;
  final String meetingLocation;
  final RxString checkIn;
  final RxString checkOut;
  final String previousLatitude;
  final String previousLongitude;
  final String latitude;
  final String longitude;
  final num meetingTimeInMins;
  final bool isCheckInEnabled;
  final bool isExpired;
  final bool isCheckOutEnabled;
  final String checkInReason;
  final String checkOutReason;
  final String attendeeCode;
  final String meetingRole;
  final String createdBy;
  final String createdDate;
  final String geoLocation;
  RxBool isCheckIn = true.obs;
  RxBool isLoading = false.obs;
  Rx<AttendanceStatus> meeting;

  MeetingDatum({
    required this.leadId,
    required this.meetingId,
    required this.customerName,
    required this.meetingDate,
    required this.startTime,
    required this.endTime,
    required this.taTinHrs,
    required this.meetingStatus,
    required this.meetingMom,
    required this.totalCount,
    required this.meetingLocation,
    required this.checkIn,
    required this.checkOut,
    required this.isExpired,
    required this.latitude,
    required this.longitude,
    required this.previousLatitude,
    required this.previousLongitude,
    required this.meetingTimeInMins,
    required this.isCheckInEnabled,
    required this.isCheckOutEnabled,
    required this.checkInReason,
    required this.checkOutReason,
    required this.createdBy,
    required this.createdDate,
    required this.meeting,
    required this.geoLocation,
    required this.meetingRole,
    required this.attendeeCode,
  });

  factory MeetingDatum.fromJson(Map<String, dynamic> json) => MeetingDatum(
        leadId: json["leadId"] ?? "",
        geoLocation: json["geoLocation"] ?? "",
        meetingId: json["meetingId"] ?? "",
        customerName: json["customerName"] ?? "",
        meetingDate: json["meetingDate"] ?? "",
        meetingRole: json["meetingRole"] ?? "",
        attendeeCode: json["attendeeCode"] ?? "",
        startTime: json["startTime"] ?? "",
        endTime: json["endTime"] ?? "",
        taTinHrs: json["taTinHrs"] ?? 0,
        isExpired: json["isExpired"] ?? true,
        meetingStatus: json["meetingStatus"] ?? "",
        meetingMom: json["meetingMOM"] ?? "",
        totalCount: json["totalCount"] ?? 0,
        meetingLocation: json["meetingLocation"] ?? "",
        checkIn: RxString(json["checkIn"] ?? ""),
        checkOut: RxString(json["checkOut"] ?? ""),
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "",
        previousLatitude: json["previousLatitude"] ?? "",
        previousLongitude: json["previousLongitude"] ?? "",
        meetingTimeInMins: json["meetingTimeInMins"] ?? 0,
        isCheckInEnabled: json["isCheckInEnabled"] ?? false,
        isCheckOutEnabled: json["isCheckOutEnabled"] ?? false,
        checkInReason: json["checkInReason"] ?? "",
        checkOutReason: json["checkOutReason"] ?? "",
        createdBy: json["createdBy"] ?? "",
        createdDate: json["createdDate"] ?? "",
        meeting: json["checkIn"] == "-" && json["checkOut"] == "-"
            ? Rx<AttendanceStatus>(AttendanceStatus.checkIn)
            : json["checkIn"] != "-" && json["checkOut"] == "-"
                ? Rx<AttendanceStatus>(AttendanceStatus.checkOut)
                : Rx<AttendanceStatus>(AttendanceStatus.completed),
      );

  Map<String, dynamic> toJson() => {
        "leadId": leadId,
        "meetingId": meetingId,
        "customerName": customerName,
        "meetingDate": meetingDate,
        "startTime": startTime,
        "endTime": endTime,
        "taTinHrs": taTinHrs,
        "meetingStatus": meetingStatus,
        "meetingMOM": meetingMom,
        "totalCount": totalCount,
        "meetingLocation": meetingLocation,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "latitude": latitude,
        "longitude": longitude,
        "previousLatitude": previousLatitude,
        "previousLongitude": previousLongitude,
        "meetingTimeInMins": meetingTimeInMins,
        "isCheckInEnabled": isCheckInEnabled,
        "isCheckOutEnabled": isCheckOutEnabled,
        "checkInReason": checkInReason,
        "checkOutReason": checkOutReason,
        "createdBy": createdBy,
        "createdDate": createdDate,
      };
}

//
// MeetingResponseModel meetingResponseModelFromJson(String str) => MeetingResponseModel.fromJson(json.decode(str));
//
// String meetingResponseModelToJson(MeetingResponseModel data) => json.encode(data.toJson());
//
// class MeetingResponseModel {
//   final bool success;
//   final List<MeetingDatum> meetingData;
//   final int totalCount;
//
//   MeetingResponseModel({
//     required this.success,
//     required this.meetingData,
//     required this.totalCount,
//   });
//
//   factory MeetingResponseModel.fromJson(Map<String, dynamic> json) => MeetingResponseModel(
//         success: json["success"],
//         meetingData: List<MeetingDatum>.from(json["data"].map((x) => MeetingDatum.fromJson(x))),
//         totalCount: json["totalCount"] ?? 0,
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "meetingData": List<dynamic>.from(meetingData.map((x) => x.toJson())),
//         "totalCount": totalCount,
//       };
// }
//
// class MeetingDatum {
//   final String leadId;
//   final String meetingId;
//   final String customerName;
//   final String meetingDate;
//   final String startTime;
//   final String endTime;
//   final int taTinHrs;
//   final String meetingStatus;
//   final String meetingMom;
//   final int totalCount;
//   final String meetingLocation;
//   final String createdBy;
//   final String createdDate;
//   final String checkIn;
//   final String checkOut;
//   RxBool isCheckIn = true.obs;
//   RxBool isLoading = false.obs;
//   Rx<AttendanceStatus> meeting;
//
//   MeetingDatum({
//     required this.leadId,
//     required this.meetingId,
//     required this.customerName,
//     required this.meetingDate,
//     required this.startTime,
//     required this.endTime,
//     required this.taTinHrs,
//     required this.meetingStatus,
//     required this.meetingMom,
//     required this.totalCount,
//     required this.meetingLocation,
//     required this.createdBy,
//     required this.createdDate,
//     required this.checkIn,
//     required this.checkOut,
//     required this.meeting,
//   });
//
//   factory MeetingDatum.fromJson(Map<String, dynamic> json) => MeetingDatum(
//         leadId: json["leadId"] ?? "",
//         meetingId: json["meetingId"] ?? "",
//         customerName: json["customerName"] ?? "",
//         meetingDate: json["meetingDate"] ?? "",
//         startTime: json["startTime"] ?? "",
//         endTime: json["endTime"] ?? "",
//         taTinHrs: json["taTinHrs"] ?? 0,
//         meetingStatus: json["meetingStatus"] ?? "",
//         meetingMom: json["meetingMOM"] ?? "",
//         totalCount: json["totalCount"] ?? 0,
//         meetingLocation: json["meetingLocation"] ?? "",
//         createdBy: json["createdBy"] ?? "",
//         createdDate: json["createdDate"] ?? "",
//         checkIn: json["checkIn"],
//         checkOut: json["checkOut"],
//         meeting: json["checkIn"] == "-" && json["checkOut"] == "-"
//             ? Rx<AttendanceStatus>(AttendanceStatus.checkIn)
//             : json["checkIn"] != "-" && json["checkOut"] == "-"
//                 ? Rx<AttendanceStatus>(AttendanceStatus.checkOut)
//                 : Rx<AttendanceStatus>(AttendanceStatus.completed),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "leadId": leadId,
//         "meetingId": meetingId,
//         "customerName": customerName,
//         "meetingDate": meetingDate,
//         "startTime": startTime,
//         "endTime": endTime,
//         "taTinHrs": taTinHrs,
//         "meetingStatus": meetingStatus,
//         "meetingMOM": meetingMom,
//         "totalCount": totalCount,
//         "meetingLocation": meetingLocation,
//         "createdBy": createdBy,
//         "createdDate": createdDate,
//       };
// }
// To parse this JSON data, do
//
//     final meetingResponseModel = meetingResponseModelFromJson(jsonString);
