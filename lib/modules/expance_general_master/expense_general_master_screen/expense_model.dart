import 'dart:convert';

ExpensesGeneralMasterListResponse expensesGeneralMasterListResponseFromJson(String str) =>
    ExpensesGeneralMasterListResponse.fromJson(json.decode(str));

String expensesGeneralMasterListResponseToJson(ExpensesGeneralMasterListResponse data) =>
    json.encode(data.toJson());

class ExpensesGeneralMasterListResponse {
  final bool success;
  final List<ExpensesGeneralMaster> expensesGeneralMasterList;
  final int totalCount;

  ExpensesGeneralMasterListResponse({
    required this.success,
    required this.expensesGeneralMasterList,
    required this.totalCount,
  });

  factory ExpensesGeneralMasterListResponse.fromJson(Map<String, dynamic> json) =>
      ExpensesGeneralMasterListResponse(
        success: json["success"] ?? false,
        expensesGeneralMasterList: (json["data"] as List?)?.map((x) => ExpensesGeneralMaster.fromJson(x)).toList() ?? [],
        totalCount: json["totalCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": expensesGeneralMasterList.map((x) => x.toJson()).toList(),
    "totalCount": totalCount,
  };
}

class ExpensesGeneralMaster {
  final num id;
  final num designationId;
  final String designation;
  final num transportModeId;
  final String transportMode;
  final num ratePerKm;
  final String createdBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;
  final bool isActive;
  final num totalCount;

  ExpensesGeneralMaster({
    required this.id,
    required this.designationId,
    required this.designation,
    required this.transportModeId,
    required this.transportMode,
    required this.ratePerKm,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.isActive,
    required this.totalCount,
  });

  factory ExpensesGeneralMaster.fromJson(Map<String, dynamic> json) => ExpensesGeneralMaster(
    id: json["id"] ?? 0,
    designationId: json["designationId"] ?? 0,
    designation: json["designation"] ?? "--",
    transportModeId: json["transportModeId"] ?? 0,
    transportMode: json["transportMode"] ?? "--",
    ratePerKm: json["ratePerKM"] ?? 0.0,
    createdBy: json["createdBy"] ?? "--",
    createdDate: json["createdDate"] ?? "--",
    modifiedBy: json["modifiedBy"] ?? "--",
    modifiedDate: json["modifiedDate"] ?? "--",
    isActive: json["isActive"] ?? false,
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "designationId": designationId,
    "designation": designation,
    "transportModeId": transportModeId,
    "transportMode": transportMode,
    "ratePerKM": ratePerKm,
    "createdBy": createdBy,
    "createdDate": createdDate,
    "modifiedBy": modifiedBy,
    "modifiedDate": modifiedDate,
    "isActive": isActive,
    "totalCount": totalCount,
  };
}
