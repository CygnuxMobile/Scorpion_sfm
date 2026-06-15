import 'dart:convert';

AddComplaintResponseModel addComplaintResponseModelFromJson(String str) => AddComplaintResponseModel.fromJson(json.decode(str));

String addComplaintResponseModelToJson(AddComplaintResponseModel data) => json.encode(data.toJson());

class AddComplaintResponseModel {
  final bool success;
  final AddComplaintData addComplaintData;
  final int totalCount;

  AddComplaintResponseModel({
    required this.success,
    required this.addComplaintData,
    required this.totalCount,
  });

  factory AddComplaintResponseModel.fromJson(Map<String, dynamic> json) => AddComplaintResponseModel(
    success: json["success"],
    addComplaintData: AddComplaintData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "addComplaintData": addComplaintData.toJson(),
    "totalCount": totalCount,
  };
}

class AddComplaintData {
  final String message;
  final int status;

  AddComplaintData({
    required this.message,
    required this.status,
  });

  factory AddComplaintData.fromJson(Map<String, dynamic> json) => AddComplaintData(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
