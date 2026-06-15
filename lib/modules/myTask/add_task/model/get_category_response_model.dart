// // To parse this JSON data, do
// //
// //     final getCategoryResponseModel = getCategoryResponseModelFromJson(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// GetCategoryResponseModel getCategoryResponseModelFromJson(String str) => GetCategoryResponseModel.fromJson(json.decode(str));
//
// String getCategoryResponseModelToJson(GetCategoryResponseModel data) => json.encode(data.toJson());
//
// class GetCategoryResponseModel {
//   final bool success;
//   final List<Categories> data;
//   final int totalCount;
//
//   GetCategoryResponseModel({
//     required this.success,
//     required this.data,
//     required this.totalCount,
//   });
//
//   factory GetCategoryResponseModel.fromJson(Map<String, dynamic> json) => GetCategoryResponseModel(
//     success: json["success"],
//     data: List<Categories>.from(json["data"].map((x) => Categories.fromJson(x))),
//     totalCount: json["totalCount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     "totalCount": totalCount,
//   };
// }
//
// class Categories {
//   final String codeType;
//   final String codeId;
//   final String codeDesc;
//
//   Categories({
//     required this.codeType,
//     required this.codeId,
//     required this.codeDesc,
//   });
//
//   factory Categories.fromJson(Map<String, dynamic> json) => Categories(
//     codeType: json["codeType"],
//     codeId: json["codeId"],
//     codeDesc: json["codeDesc"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "codeType": codeType,
//     "codeId": codeId,
//     "codeDesc": codeDesc,
//   };
// }
