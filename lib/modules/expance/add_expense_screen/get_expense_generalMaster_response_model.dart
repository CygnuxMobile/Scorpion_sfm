import 'dart:convert';

GetExpenseGeneralMasterResponseModel getExpenseGeneralMasterResponseModelFromJson(String str) => GetExpenseGeneralMasterResponseModel.fromJson(json.decode(str));

String getExpenseGeneralMasterResponseModelToJson(GetExpenseGeneralMasterResponseModel data) => json.encode(data.toJson());

class GetExpenseGeneralMasterResponseModel {
  final bool success;
  final List<GetExpenseGeneralMasterDatum> getExpenseGeneralMasterData;
  final int totalCount;

  GetExpenseGeneralMasterResponseModel({
    required this.success,
    required this.getExpenseGeneralMasterData,
    required this.totalCount,
  });

  factory GetExpenseGeneralMasterResponseModel.fromJson(Map<String, dynamic> json) => GetExpenseGeneralMasterResponseModel(
    success: json["success"],
    getExpenseGeneralMasterData: List<GetExpenseGeneralMasterDatum>.from(json["data"].map((x) => GetExpenseGeneralMasterDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "GetExpenseGeneralMasterData": List<dynamic>.from(getExpenseGeneralMasterData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class GetExpenseGeneralMasterDatum {
  final int id;
  final int designationId;
  final String designation;
  final int transportModeId;
  final String transportMode;
  final num ratePerKm;
  final String createdBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;
  final bool isActive;
  final num totalCount;

  GetExpenseGeneralMasterDatum({
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

  factory GetExpenseGeneralMasterDatum.fromJson(Map<String, dynamic> json) => GetExpenseGeneralMasterDatum(
    id: json["id"]??0,
    designationId: json["designationId"]??0,
    designation: json["designation"]??"",
    transportModeId: json["transportModeId"]??0,
    transportMode: json["transportMode"]??"",
    ratePerKm: json["ratePerKM"]??0,
    createdBy: json["createdBy"]??"",
    createdDate: json["createdDate"]??"",
    modifiedBy: json["modifiedBy"]??"",
    modifiedDate: json["modifiedDate"]??"",
    isActive: json["isActive"]??false,
    totalCount: json["totalCount"]??0,
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
