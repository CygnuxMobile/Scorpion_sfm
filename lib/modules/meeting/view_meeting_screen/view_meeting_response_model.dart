import 'dart:convert';

ViewMeetingResponseModel viewMeetingResponseModelFromJson(String str) => ViewMeetingResponseModel.fromJson(json.decode(str));

// String viewMeetingResponseModelToJson(ViewMeetingResponseModel data) => json.encode(data.toJson());

class ViewMeetingResponseModel {
  final bool success;
  final MeetingViewData meetingViewData;
  final num totalCount;

  ViewMeetingResponseModel({
    required this.success,
    required this.meetingViewData,
    required this.totalCount,
  });

  factory ViewMeetingResponseModel.fromJson(Map<String, dynamic> json) => ViewMeetingResponseModel(
    success: json["success"],
    meetingViewData: MeetingViewData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  // Map<String, dynamic> toJson() => {
  //   "success": success,
  //   "meetingViewData": meetingViewData.toJson(),
  //   "totalCount": totalCount,
  // };
}

class MeetingViewData {
  final String contactName;
  final String address;
  final String contactNo;
  final String email;
  final String location;
  final num meetingTypeId;
  final String meetingType;
  final String leadSource;
  final String attendees;
  final String attendeeNames;
  final String geoLocation;
  final String checkInDateTime;
  final String checkOutDateTime;
  final double latitude;
  final double longitude;
  final String meetingPurpose;
  final String meetingLocationName;
  String checkInLocation;
  String checkOutLocation;
  final String meetingAddress;
  final String leadId;
  final String meetingId;
  final String customerName;
  final String meetingDate;
  final String modifiedDate;
  final String startTime;
  final String endTime;
  final num taTinHrs;
  final String meetingStatus;
  final String meetingMom;
  final num totalCount;
  final String meetingLocation;
  final String modifiedBy;
  final String checkIn;
  final String checkOut;
  final num meetingTimeInMins;
  final bool isCheckInEnabled;
  final bool isCheckOutEnabled;
  final String checkInReason;
  final String checkOutReason;
  final String createdBy;
  final String createdDate;
  final String checkOutLatitude;
  final String checkOutLongitude;

  MeetingViewData({
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
    required this.geoLocation,
    required this.checkInDateTime,
    required this.checkOutDateTime,
    required this.latitude,
    required this.longitude,
    required this.meetingPurpose,
    required this.modifiedBy,
    required this.meetingLocationName,
    required this.checkOutLocation,
    required this.meetingAddress,
    required this.checkInLocation,
    required this.leadId,
    required this.meetingId,
    required this.customerName,
    required this.meetingDate,
    required this.startTime,
    required this.endTime,
    required this.taTinHrs,
    required this.meetingStatus,
    required this.modifiedDate,
    required this.meetingMom,
    required this.totalCount,
    required this.meetingLocation,
    required this.checkIn,
    required this.checkOut,
    required this.meetingTimeInMins,
    required this.isCheckInEnabled,
    required this.isCheckOutEnabled,
    required this.checkInReason,
    required this.checkOutReason,
    required this.createdBy,
    required this.createdDate,
    required this.checkOutLongitude,
    required this.checkOutLatitude,
  });

  factory MeetingViewData.fromJson(Map<String, dynamic> json) => MeetingViewData(
    contactName: json["contactName"] ?? "",
    address: json["address"] ?? "",
    contactNo: json["contactNo"] ?? "",
    email: json["email"] ?? "",
    location: json["location"] ?? "",
    meetingTypeId: json["meetingTypeId"] ?? 0,
    meetingType: json["meetingType"] ?? "",
    leadSource: json["leadSource"] ?? "",
    attendees: json["attendees"] ?? "",
    attendeeNames: json["attendeeNames"] ?? "",
    geoLocation: json["geoLocation"] ?? "",
    modifiedDate: json["modifiedDate"] ?? "",
    checkInDateTime: json["checkInDateTime"] ?? "",
    checkOutDateTime: json["checkOutDateTime"] ?? "",
    latitude: json["latitude"]?.toDouble() ?? 0.0,
    longitude: json["longitude"]?.toDouble() ?? 0.0,
    meetingPurpose: json["meetingPurpose"] ?? "",
    meetingLocationName: json["meetingLocationName"]?? "",
    modifiedBy: json["modifiedBy"]?? "",
    checkInLocation: json["checkInLocation"]?? "",
    checkOutLocation: json["checkOutLocation"]?? "",
    meetingAddress: json["meetingAddress"]?? "",
    leadId: json["leadId"]?? "",
    meetingId: json["meetingId"]?? "",
    customerName: json["customerName"]?? "",
    meetingDate: json["meetingDate"]?? "",
    startTime: json["startTime"]?? "",
    endTime: json["endTime"]?? "",
    taTinHrs: json["taTinHrs"]?? 0,
    meetingStatus: json["meetingStatus"]?? "",
    meetingMom: json["meetingMOM"]?? "",
    totalCount: json["totalCount"]?? 0,
    meetingLocation: json["meetingLocation"]?? "",
    checkIn: json["checkIn"]?? "",
    checkOut: json["checkOut"]?? "",
    meetingTimeInMins: json["meetingTimeInMins"]?? "",
    isCheckInEnabled: json["isCheckInEnabled"]?? false,
    isCheckOutEnabled: json["isCheckOutEnabled"]?? false,
    checkInReason: json["checkInReason"]?? "",
    checkOutReason: json["checkOutReason"]?? "",
    createdBy: json["createdBy"]?? "",
    createdDate: json["createdDate"]?? "",
    checkOutLatitude: json["checkOutLatitude"] ?? 0.0,
    checkOutLongitude: json["checkOutLongitude"] ?? 0.0,
  );
  //
  // Map<String, dynamic> toJson() => {
  //   "contactName": contactName,
  //   "address": address,
  //   "contactNo": contactNo,
  //   "email": email,
  //   "location": location,
  //   "meetingTypeId": meetingTypeId,
  //   "meetingType": meetingType,
  //   "leadSource": leadSource,
  //   "attendees": attendees,
  //   "attendeeNames": attendeeNames,
  //   "geoLocation": geoLocation,
  //   "checkInDateTime": checkInDateTime,
  //   "checkOutDateTime": checkOutDateTime,
  //   "latitude": latitude,
  //   "longitude": longitude,
  //   "meetingPurpose": meetingPurpose,
  //   "modifiedBy": modifiedBy,
  //   "meetingLocationName": meetingLocationName,
  //   "checkInOutLocation": checkInOutLocation,
  //   "leadId": leadId,
  //   "meetingId": meetingId,
  //   "customerName": customerName,
  //   "meetingDate": meetingDate,
  //   "startTime": startTime,
  //   "endTime": endTime,
  //   "taTinHrs": taTinHrs,
  //   "meetingStatus": meetingStatus,
  //   "meetingMOM": meetingMom,
  //   "totalCount": totalCount,
  //   "meetingLocation": meetingLocation,
  //   "checkIn": checkIn,
  //   "checkOut": checkOut,
  //   "meetingTimeInMins": meetingTimeInMins,
  //   "isCheckInEnabled": isCheckInEnabled,
  //   "isCheckOutEnabled": isCheckOutEnabled,
  //   "checkInReason": checkInReason,
  //   "checkOutReason": checkOutReason,
  //   "createdBy": createdBy,
  //   "createdDate": createdDate,
  // };
}
