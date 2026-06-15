import 'dart:convert';

ViewTaskResponseModel viewTaskResponseModelFromJson(String str) => ViewTaskResponseModel.fromJson(json.decode(str));

String viewTaskResponseModelToJson(ViewTaskResponseModel data) => json.encode(data.toJson());

class ViewTaskResponseModel {
  final bool success;
  final Task data;
  final int totalCount;

  ViewTaskResponseModel({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory ViewTaskResponseModel.fromJson(Map<String, dynamic> json) => ViewTaskResponseModel(
    success: json["success"],
    data: Task.fromJson(json["data"]),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "totalCount": totalCount,
  };
}

class Task {
  final String taskDescription;
  final String taskName;
  final String leadId;
  final int priorityId;
  final String priority;
  final int leadCategoryId;
  final String leadCategory;
  final String assignedTos;
  final String assignedToNames;
  final String taskId;
  final String leadCategoryName;
  final String taskDate;
  final String customerName;
  final String startTime;
  final String endTime;
  final String taskStatus;

  Task({
    required this.taskDescription,
    required this.taskName,
    required this.leadId,
    required this.priorityId,
    required this.priority,
    required this.leadCategoryId,
    required this.leadCategory,
    required this.assignedTos,
    required this.assignedToNames,
    required this.taskId,
    required this.leadCategoryName,
    required this.taskDate,
    required this.customerName,
    required this.startTime,
    required this.endTime,
    required this.taskStatus,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    taskDescription: json["taskDescription"],
    taskName: json["taskName"],
    leadId: json["leadId"],
    priorityId: json["priorityId"],
    priority: json["priority"],
    leadCategoryId: json["leadCategoryId"],
    leadCategory: json["leadCategory"],
    assignedTos: json["assignedTos"],
    assignedToNames: json["assignedToNames"],
    taskId: json["taskId"],
    leadCategoryName: json["leadCategoryName"],
    taskDate: json["taskDate"],
    customerName: json["customerName"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    taskStatus: json["taskStatus"],
  );

  Map<String, dynamic> toJson() => {
    "taskDescription": taskDescription,
    "taskName": taskName,
    "leadId": leadId,
    "priorityId": priorityId,
    "priority": priority,
    "leadCategoryId": leadCategoryId,
    "leadCategory": leadCategory,
    "assignedTos": assignedTos,
    "assignedToNames": assignedToNames,
    "taskId": taskId,
    "leadCategoryName": leadCategoryName,
    "taskDate": taskDate,
    "customerName": customerName,
    "startTime": startTime,
    "endTime": endTime,
    "taskStatus": taskStatus,
  };
}
