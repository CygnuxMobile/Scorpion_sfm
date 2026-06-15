// import 'dart:convert';
//
// EditMeetingResponseModel editMeetingResponseModelFromJson(String str) => EditMeetingResponseModel.fromJson(json.decode(str));
//
// String editMeetingResponseModelToJson(EditMeetingResponseModel data) => json.encode(data.toJson());
//
// class EditMeetingResponseModel {
//   final bool success;
//   final meetingData data;
//   final int totalCount;
//
//   EditMeetingResponseModel({
//     required this.success,
//     required this.data,
//     required this.totalCount,
//   });
//
//   factory EditMeetingResponseModel.fromJson(Map<String, dynamic> json) => EditMeetingResponseModel(
//     success: json["success"],
//     data: meetingData.fromJson(json["data"]),
//     totalCount: json["totalCount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": data.toJson(),
//     "totalCount": totalCount,
//   };
// }
//
// class meetingData {
//   final String contactName;
//   final String address;
//   final String contactNo;
//   final String email;
//   final String location;
//   final int meetingTypeId;
//   final String meetingType;
//   final String leadSource;
//   final String attendees;
//   final String attendeeNames;
//   final double latitude;
//   final double longitude;
//   final String meetingPurpose;
//   final String leadId;
//   final String meetingId;
//   final String customerName;
//   final String meetingDate;
//   final String startTime;
//   final String endTime;
//   final int taTinHrs;
//   final String meetingStatus;
//   final String meetingMom;
//   final String meetingLocation;
//   final String createdBy;
//   final String modifiedBy;
//   final DateTime createdDate;
//
//   meetingData({
//     required this.contactName,
//     required this.address,
//     required this.contactNo,
//     required this.email,
//     required this.location,
//     required this.meetingTypeId,
//     required this.meetingType,
//     required this.leadSource,
//     required this.attendees,
//     required this.attendeeNames,
//     required this.latitude,
//     required this.longitude,
//     required this.meetingPurpose,
//     required this.leadId,
//     required this.meetingId,
//     required this.customerName,
//     required this.meetingDate,
//     required this.startTime,
//     required this.endTime,
//     required this.taTinHrs,
//     required this.meetingStatus,
//     required this.meetingMom,
//     required this.meetingLocation,
//     required this.createdBy,
//     required this.modifiedBy,
//     required this.createdDate,
//   });
//
//   factory meetingData.fromJson(Map<String, dynamic> json) => meetingData(
//     contactName: json["contactName"],
//     address: json["address"],
//     contactNo: json["contactNo"],
//     email: json["email"],
//     location: json["location"],
//     meetingTypeId: json["meetingTypeId"],
//     meetingType: json["meetingType"],
//     leadSource: json["leadSource"] ?? '',
//     attendees: json["attendees"],
//     attendeeNames: json["attendeeNames"],
//     latitude: json["latitude"]?.toDouble() ?? 0.0,
//     longitude: json["longitude"]?.toDouble() ?? 0.0,
//     meetingPurpose: json["meetingPurpose"],
//     leadId: json["leadId"],
//     meetingId: json["meetingId"],
//     customerName: json["customerName"],
//     meetingDate: json["meetingDate"],
//     startTime: json["startTime"],
//     endTime: json["endTime"],
//     taTinHrs: json["taTinHrs"],
//     meetingStatus: json["meetingStatus"],
//     meetingMom: json["meetingMOM"],
//     meetingLocation: json["meetingLocation"],
//     createdBy: json["createdBy"],
//     modifiedBy: json["modifiedBy"] ?? "",
//     createdDate: DateTime.parse(json["createdDate"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "contactName": contactName,
//     "address": address,
//     "contactNo": contactNo,
//     "email": email,
//     "location": location,
//     "meetingTypeId": meetingTypeId,
//     "meetingType": meetingType,
//     "leadSource": leadSource,
//     "attendees": attendees,
//     "attendeeNames": attendeeNames,
//     "latitude": latitude,
//     "longitude": longitude,
//     "meetingPurpose": meetingPurpose,
//     "leadId": leadId,
//     "meetingId": meetingId,
//     "customerName": customerName,
//     "meetingDate": meetingDate,
//     "startTime": startTime,
//     "endTime": endTime,
//     "taTinHrs": taTinHrs,
//     "meetingStatus": meetingStatus,
//     "meetingMOM": meetingMom,
//     "meetingLocation": meetingLocation,
//     "createdBy": createdBy,
//     "modifiedBy": modifiedBy,
//     "createdDate": createdDate.toIso8601String(),
//   };
// }
// To parse this JSON data, do
//
//     final editMeetingResponseModel = editMeetingResponseModelFromJson(jsonString);

import 'dart:convert';

EditMeetingResponseModel editMeetingResponseModelFromJson(String str) =>
    EditMeetingResponseModel.fromJson(json.decode(str));

String editMeetingResponseModelToJson(EditMeetingResponseModel data) => json.encode(data.toJson());

class EditMeetingResponseModel {
  final bool success;
  final meetingData data;
  final int totalCount;

  EditMeetingResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory EditMeetingResponseModel.fromJson(Map<String, dynamic> json) => EditMeetingResponseModel(
        success: json["success"],
        data: meetingData.fromJson(json["data"]),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "totalCount": totalCount,
      };
}

class meetingData {
  final String contactName;
  final String address;
  final String contactNo;
  final String email;
  final String location;
  final int meetingTypeId;
  final String meetingType;
  final String leadSource;
  final String attendees;
  final String attendeeNames;
  final double latitude;
  final double longitude;
  final String meetingPurpose;
  final String meetingLocationName;
  final String geoLocation;
  final String createLatitude;
  final String createLongitude;
  final String leadId;
  final String meetingId;
  final String customerName;
  final String meetingDate;
  final String startTime;
  final String endTime;
  final int taTinHrs;
  final String meetingStatus;
  final String meetingMom;
  final String meetingLocation;
  final String createdBy;
  final String modifiedBy;
  final String attendeeCode;
  final DateTime createdDate;

  meetingData({
    required this.contactName,
    required this.address,
    required this.contactNo,
    required this.email,
    required this.location,
    required this.meetingTypeId,
    required this.meetingType,
    required this.leadSource,
    required this.attendees,
    required this.attendeeNames,
    required this.latitude,
    required this.longitude,
    required this.meetingPurpose,
    required this.meetingLocationName,
    required this.leadId,
    required this.meetingId,
    required this.customerName,
    required this.meetingDate,
    required this.startTime,
    required this.endTime,
    required this.taTinHrs,
    required this.meetingStatus,
    required this.meetingMom,
    required this.meetingLocation,
    required this.createdBy,
    required this.attendeeCode,
    required this.modifiedBy,
    required this.createdDate,
    required this.createLatitude,
    required this.createLongitude,
    required this.geoLocation
  });

  factory meetingData.fromJson(Map<String, dynamic> json) => meetingData(
        contactName: json["contactName"],
        address: json["address"],
        contactNo: json["contactNo"],
        email: json["email"],
        location: json["location"],
        meetingTypeId: json["meetingTypeId"],
        meetingType: json["meetingType"] ?? '',
        leadSource: json["leadSource"] ?? "",
        attendees: json["attendees"],
        attendeeNames: json["attendeeNames"] ?? "",
        latitude: json["latitude"]?.toDouble() ?? 0.0,
        longitude: json["longitude"]?.toDouble() ?? 0.0,
        meetingPurpose: json["meetingPurpose"],
        meetingLocationName: json["meetingLocationName"],
        leadId: json["leadId"],
        meetingId: json["meetingId"],
        customerName: json["customerName"],
        meetingDate: json["meetingDate"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        taTinHrs: json["taTinHrs"],
        meetingStatus: json["meetingStatus"],
        attendeeCode: json["attendeeCode"],
        meetingMom: json["meetingMOM"],
        meetingLocation: json["meetingLocation"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"] ?? '',
        createLatitude: json['createLatitude'] ?? '',
        createLongitude: json['createLongitude'] ?? '',
        geoLocation: json["geoLocation"] ?? '',
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "contactName": contactName,
        "address": address,
        "contactNo": contactNo,
        "email": email,
        "location": location,
        "meetingTypeId": meetingTypeId,
        "meetingType": meetingType,
        "leadSource": leadSource,
        "attendees": attendees,
        "attendeeNames": attendeeNames,
        "latitude": latitude,
        "longitude": longitude,
        "meetingPurpose": meetingPurpose,
        "meetingLocationName": meetingLocationName,
        "leadId": leadId,
        "meetingId": meetingId,
        "customerName": customerName,
        "meetingDate": meetingDate,
        "startTime": startTime,
        "endTime": endTime,
        "taTinHrs": taTinHrs,
        "meetingStatus": meetingStatus,
        "meetingMOM": meetingMom,
        "meetingLocation": meetingLocation,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "createdDate": createdDate.toIso8601String(),
      };
}
