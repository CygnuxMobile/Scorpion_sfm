import 'dart:convert';

GetDocDataResponseModel getDocDataResponseModelFromJson(String str) => GetDocDataResponseModel.fromJson(json.decode(str));

String getDocDataResponseModelToJson(GetDocDataResponseModel data) => json.encode(data.toJson());

class GetDocDataResponseModel {
  final bool success;
  final GetDocData getDocData;
  final int totalCount;

  GetDocDataResponseModel({
    required this.success,
    required this.getDocData,
    required this.totalCount,
  });

  factory GetDocDataResponseModel.fromJson(Map<String, dynamic> json) => GetDocDataResponseModel(
        success: json["success"],
        getDocData: GetDocData.fromJson(json["data"]),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "getDocData": getDocData.toJson(),
        "totalCount": totalCount,
      };
}

class GetDocData {
  final String documentNo;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String edd;
  final String documentDate;
  final String origin;
  final String destination;
  final String currentStatus;
  final String currentCode;
  final String currentLocation;

  GetDocData({
    required this.documentNo,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.edd,
    required this.documentDate,
    required this.origin,
    required this.destination,
    required this.currentCode,
    required this.currentStatus,
    required this.currentLocation,
  });

  factory GetDocData.fromJson(Map<String, dynamic> json) => GetDocData(
        documentNo: json["documentNo"] ?? '',
        customerId: json["customerID"] ?? '',
        customerName: json["customerName"] ?? '',
        customerEmail: json["customerEmail"] ?? '',
        edd: json["edd"] ?? '',
        documentDate: json["documentDate"] ?? '',
        origin: json["origin"] ?? '',
        destination: json["destination"] ?? '',
        currentCode: json['currentLocation'] ?? '',
        currentStatus: json['currentStatus'] ?? '',
        currentLocation: json['currentLocation'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "documentNo": documentNo,
        "customerID": customerId,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "edd": edd,
        "documentDate": documentDate,
        "origin": origin,
        "destination": destination,
      };
}
