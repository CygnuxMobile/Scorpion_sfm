import 'dart:convert';

AddExpenseResponseModel addExpenseResponseModelFromJson(String str) => AddExpenseResponseModel.fromJson(json.decode(str));

String addExpenseResponseModelToJson(AddExpenseResponseModel data) => json.encode(data.toJson());

class AddExpenseResponseModel {
  final bool success;
  final ExpenseData data;
  final int totalCount;

  AddExpenseResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory AddExpenseResponseModel.fromJson(Map<String, dynamic> json) => AddExpenseResponseModel(
    success: json["success"],
    data: ExpenseData.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "totalCount": totalCount,
  };
}

class ExpenseData {
  final String message;
  final String id;
  final int status;

  ExpenseData({
    required this.message,
    required this.status,
    required this.id,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) => ExpenseData(
    message: json["message"],
    status: json["status"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
