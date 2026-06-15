import 'dart:convert';

GetAssignResponse getAssignResponseFromJson(String str) => GetAssignResponse.fromJson(json.decode(str));

String getAssignResponseToJson(GetAssignResponse data) => json.encode(data.toJson());

class GetAssignResponse {
  final bool success;
  final List<Assign> data;
  final int totalCount;

  GetAssignResponse({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  GetAssignResponse copyWith({
    bool? success,
    List<Assign>? data,
    int? totalCount,
  }) =>
      GetAssignResponse(
        success: success ?? this.success,
        data: data ?? this.data,
        totalCount: totalCount ?? this.totalCount,
      );

  factory GetAssignResponse.fromJson(Map<String, dynamic> json) => GetAssignResponse(
    success: json["success"],
    data: List<Assign>.from(json["data"].map((x) => Assign.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class Assign {
  final String userId;
  final String userName;
  final String? emailId;

  Assign({
    required this.userId,
    required this.userName,
    this.emailId,
  });


  factory Assign.fromJson(Map<String, dynamic> json) => Assign(
    userId: json["userId"] ?? '',
    userName: json["userName"] ?? '',
    emailId: json["emailId"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
  };
}
