import 'dart:convert';

GetBranchResponseModel getBranchResponseModelFromJson(String str) => GetBranchResponseModel.fromJson(json.decode(str));

String getBranchResponseModelToJson(GetBranchResponseModel data) => json.encode(data.toJson());

class GetBranchResponseModel {
  final bool isSuccess;
  final List<Branch> data;

  GetBranchResponseModel({
    required this.isSuccess,
    required this.data,
  });

  factory GetBranchResponseModel.fromJson(Map<String, dynamic> json) => GetBranchResponseModel(
        isSuccess: json["isSuccess"],
        data: List<Branch>.from(json["data"].map((x) => Branch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Branch {
  final String locCode;
  final String locName;

  Branch({
    required this.locCode,
    required this.locName,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        locCode: json["locCode"],
        locName: json["locName"],
      );

  Map<String, dynamic> toJson() => {
        "locCode": locCode,
        "locName": locName,
      };
}
