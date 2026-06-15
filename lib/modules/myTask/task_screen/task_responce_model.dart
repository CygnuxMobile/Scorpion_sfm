
import 'dart:convert';

TaskDataResponseModel taskDataResponseModelFromJson(String str) => TaskDataResponseModel.fromJson(json.decode(str));

String taskDataResponseModelToJson(TaskDataResponseModel data) => json.encode(data.toJson());

class TaskDataResponseModel {
  final bool success;
  final List<Task> data;
  final int totalCount;

  TaskDataResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory TaskDataResponseModel.fromJson(Map<String, dynamic> json) => TaskDataResponseModel(
    success: json["success"],
    data: List<Task>.from(json["data"].map((x) => Task.fromJson(x))),
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class Task {
  final String taskId;
  final String leadCategoryName;
  final String taskDate;
  final String customerName;
  final String startTime;
  final String endTime;
  final String taskStatus;
  final int totalCount;

  Task({
    required this.taskId,
    required this.leadCategoryName,
    required this.taskDate,
    required this.customerName,
    required this.startTime,
    required this.endTime,
    required this.taskStatus,
    required this.totalCount,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    taskId: json["taskId"],
    leadCategoryName: json["leadCategoryName"],
    taskDate: json["taskDate"],
    customerName: json["customerName"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    taskStatus: json["taskStatus"],
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "taskId": taskId,
    "leadCategoryName": leadCategoryName,
    "taskDate": taskDate,
    "customerName": customerName,
    "startTime": startTime,
    "endTime": endTime,
    "taskStatus": taskStatus,
    "totalCount": totalCount,
  };
}
