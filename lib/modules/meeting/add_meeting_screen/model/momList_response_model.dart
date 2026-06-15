import 'dart:convert';

MomListResponseModel momListResponseModelFromJson(String str) => MomListResponseModel.fromJson(json.decode(str));

String momListResponseModelToJson(MomListResponseModel data) => json.encode(data.toJson());

class MomListResponseModel {
  final bool success;
  final List<MomListDatum> momListData;
  final int totalCount;

  MomListResponseModel({
    required this.success,
    required this.momListData,
    required this.totalCount,
  });

  factory MomListResponseModel.fromJson(Map<String, dynamic> json) => MomListResponseModel(
    success: json["success"],
    momListData: List<MomListDatum>.from(json["data"].map((x) => MomListDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "momListData": List<dynamic>.from(momListData.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class MomListDatum {
  final int? id;
  final String? moM;

  MomListDatum({
     this.id,
     this.moM,
  });

  factory MomListDatum.fromJson(Map<String, dynamic> json) => MomListDatum(
    id: json["id"]??0,
    moM: json["moM"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "moM": moM,
  };
}
