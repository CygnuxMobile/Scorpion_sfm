import 'dart:convert';

AttendanceResponse attendanceResponseFromJson(String str) => AttendanceResponse.fromJson(json.decode(str));

String attendanceResponseToJson(AttendanceResponse data) => json.encode(data.toJson());

class AttendanceResponse {
  final bool success;
  final Data data;
  final int totalCount;

  AttendanceResponse({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  AttendanceResponse copyWith({
    bool? success,
    Data? data,
    int? totalCount,
  }) =>
      AttendanceResponse(
        success: success ?? this.success,
        data: data ?? this.data,
        totalCount: totalCount ?? this.totalCount,
      );

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) => AttendanceResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "totalCount": totalCount,
      };
}

class Data {
  final String userId;
  final bool isPunchIn;
  final String punchIn;
  final bool isPunchOut;
  final String punchOut;
  final double punchInLat;
  final double punchInLng;
  final double punchOutLat;
  final double punchOutLng;
  final double previousLatitude;
  final double previousLongitude;

  Data(
      {required this.userId,
      required this.isPunchIn,
      required this.punchIn,
      required this.isPunchOut,
      required this.punchOut,
      required this.punchInLat,
      required this.punchInLng,
      required this.punchOutLat,
      required this.punchOutLng,
      required this.previousLatitude,
      required this.previousLongitude});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      userId: json["userID"],
      isPunchIn: json["isPunchIn"] ?? false,
      punchIn: json["punchIn"] ?? "--:--:--",
      isPunchOut: json["isPunchOut"] ?? false,
      punchOut: json["punchOut"] ?? "--:--:--",
      punchInLat: json["punchInLat"] ?? 0.0,
      punchInLng: json["punchInLng"] ?? 0.0,
      punchOutLat: json["punchOutLat"] ?? 0.0,
      punchOutLng: json["punchOutLng"] ?? 0.0,
      previousLatitude: json["previousLatitude"] ?? 0.0,
      previousLongitude: json["previousLongitude"] ?? 0.0);

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "isPunchIn": isPunchIn,
        "punchIn": punchIn,
        "isPunchOut": isPunchOut,
        "punchOut": punchOut,
        "punchInLat": punchInLat,
        "punchInLng": punchInLng,
        "punchOutLat": punchOutLat,
        "punchOutLng": punchOutLng,
      };
}
