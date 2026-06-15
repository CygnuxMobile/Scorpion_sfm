import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final bool isSuccess;
  final Data data;

  LoginModel({required this.isSuccess, required this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(isSuccess: json["isSuccess"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"isSuccess": isSuccess, "data": data.toJson()};
}

class Data {
  final String token;
  final String refreshToken;
  final String branchCode;
  final String userId;
  final String name;
  final String userType;
  final String emailId;
  final String baseCompanyCode;
  final String branchName;
  final String finYear;
  final String designationId;
  final String designation;
  final String reportingLoc;
  final String reportLocName;
  final List<MultiLocation> multiLocation;

  Data({
    required this.token,
    required this.refreshToken,
    required this.branchCode,
    required this.userId,
    required this.name,
    required this.userType,
    required this.emailId,
    required this.baseCompanyCode,
    required this.branchName,
    required this.finYear,
    required this.designationId,
    required this.designation,
    required this.reportingLoc,
    required this.reportLocName,
    required this.multiLocation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"] ?? "",
    refreshToken: json["refreshToken"] ?? "",
    branchCode: json["branchCode"] ?? "",
    userId: json["userId"] ?? "",
    name: json["name"] ?? "",
    userType: json["userType"] ?? "",
    emailId: json["emailId"] ?? "",
    baseCompanyCode: json["baseCompanyCode"] ?? "",
    branchName: json["branchName"] ?? "",
    finYear: json["finYear"] ?? "",
    designationId: json["designationId"] ?? "",
    designation: json["designation"] ?? "",
    reportingLoc: json["reportingLoc"] ?? "",
    reportLocName: json["reportLocName"] ?? "",
    multiLocation: List<MultiLocation>.from(json["multiLocation"].map((x) => MultiLocation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "refreshToken": refreshToken,
    "branchCode": branchCode,
    "userId": userId,
    "name": name,
    "userType": userType,
    "emailId": emailId,
    "baseCompanyCode": baseCompanyCode,
    "branchName": branchName,
    "finYear": finYear,
    "designationId": designationId,
    "designation": designation,
    "reportingLoc": reportingLoc,
    "reportLocName": reportLocName,
    "multiLocation": List<dynamic>.from(multiLocation.map((x) => x.toJson())),
  };
}

class MultiLocation {
  final String locCode;
  final String locName;

  MultiLocation({required this.locCode, required this.locName});

  factory MultiLocation.fromJson(Map<String, dynamic> json) => MultiLocation(locCode: json["locCode"], locName: json["locName"]);

  Map<String, dynamic> toJson() => {"locCode": locCode, "locName": locName};
}
