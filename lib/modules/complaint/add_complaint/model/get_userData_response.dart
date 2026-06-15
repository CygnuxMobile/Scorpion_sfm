
import 'dart:convert';

GetUserDataResponseModel getUserDataResponseModelFromJson(String str) => GetUserDataResponseModel.fromJson(json.decode(str));

String getUserDataResponseModelToJson(GetUserDataResponseModel data) => json.encode(data.toJson());

class GetUserDataResponseModel {
  final bool success;
  final UserData userData;
  final int totalCount;

  GetUserDataResponseModel({
    required this.success,
    required this.userData,
    required this.totalCount,
  });

  factory GetUserDataResponseModel.fromJson(Map<String, dynamic> json) => GetUserDataResponseModel(
    success: json["success"],
    userData: UserData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "UserData": userData.toJson(),
    "totalCount": totalCount,
  };
}

class UserData {
  final String userId;
  final String userName;
  final String managerId;
  final String managerName;
  final String emailId;
  final String personalEmail;
  final String complaintManagerId;
  final String complaintManagerName;
  final String complaintManagerEmail;

  UserData({
    required this.userId,
    required this.userName,
    required this.managerId,
    required this.managerName,
    required this.emailId,
    required this.personalEmail,
    required this.complaintManagerId,
    required this.complaintManagerName,
    required this.complaintManagerEmail,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userId: json["userId"]??"",
    userName: json["userName"]??"",
    managerId: json["managerId"]??"",
    managerName: json["managerName"]??"",
    emailId: json["emailId"]??"",
    personalEmail: json["personalEmail"]??"",
    complaintManagerId: json["complaintManagerID"]??"",
    complaintManagerName: json["complaintManagerName"]??"",
    complaintManagerEmail: json["complaintManagerEmail"]??"",
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "managerId": managerId,
    "managerName": managerName,
    "emailId": emailId,
    "personalEmail": personalEmail,
    "complaintManagerID": complaintManagerId,
    "complaintManagerName": complaintManagerName,
    "complaintManagerEmail": complaintManagerEmail,
  };
}
