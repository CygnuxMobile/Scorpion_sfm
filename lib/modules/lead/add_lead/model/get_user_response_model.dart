import 'dart:convert';

GetUserResponseModel getUserResponseModelFromJson(String str) => GetUserResponseModel.fromJson(json.decode(str));

String getUserResponseModelToJson(GetUserResponseModel data) => json.encode(data.toJson());

class GetUserResponseModel {
  final bool isSuccess;
  final List<User> data;

  GetUserResponseModel({
    required this.isSuccess,
    required this.data,
  });

  factory GetUserResponseModel.fromJson(Map<String, dynamic> json) => GetUserResponseModel(
        isSuccess: json["isSuccess"],
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class User {
  final String userId;
  final String name;

  User({
    required this.userId,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"] ?? '',
        name: json["name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
      };
}

GetAssignedResponseModel getAssignedResponseModelFromJson(String str) => GetAssignedResponseModel.fromJson(json.decode(str));

class GetAssignedResponseModel {
  final bool isSuccess;
  final List<AssignedUser> data;

  GetAssignedResponseModel({
    required this.isSuccess,
    required this.data,
  });

  factory GetAssignedResponseModel.fromJson(Map<String, dynamic> json) => GetAssignedResponseModel(
        isSuccess: json["success"],
        data: List<AssignedUser>.from(json["data"].map((x) => AssignedUser.fromJson(x))),
      );
}

class AssignedUser {
  final String userId;
  final String name;

  AssignedUser({
    required this.userId,
    required this.name,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) => AssignedUser(
        userId: json["userId"] ?? '',
        name: json["name"].toString(),
      );
}
