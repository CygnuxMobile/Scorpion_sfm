// To parse this JSON data, do
//
//     final myCalendarResponceModel = myCalendarResponceModelFromJson(jsonString);

import 'dart:convert';

MyCalendarResponceModel myCalendarResponceModelFromJson(String str) => MyCalendarResponceModel.fromJson(json.decode(str));

String myCalendarResponceModelToJson(MyCalendarResponceModel data) => json.encode(data.toJson());

class MyCalendarResponceModel {
  final bool success;
  final List<Datum> data;
  final int totalCount;

  MyCalendarResponceModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory MyCalendarResponceModel.fromJson(Map<String, dynamic> json) => MyCalendarResponceModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalCount: json["totalCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
      };
}

class Datum {
  final String title;
  final DateTime start;
  final DateTime end;
  final String className;
  final String meetingId;
  final String callId;
  final bool isAllDayEvent;
  final String attendeeCode;

  Datum({
    required this.title,
    required this.start,
    required this.end,
    required this.className,
    required this.meetingId,
    required this.callId,
    required this.isAllDayEvent,
    required this.attendeeCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"] ?? "",
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        className: json["className"] ?? "",
        meetingId: json["meetingId"] ?? "",
        callId: json["callId"] ?? "",
        isAllDayEvent: json["isAllDayEvent"] ?? true,
        attendeeCode: json["attendeeCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "start": start.toIso8601String(),
        "end": end.toIso8601String(),
        "className": className,
        "meetingId": meetingId,
        "callId": callId,
        "attendeeCode": attendeeCode,
      };
}
