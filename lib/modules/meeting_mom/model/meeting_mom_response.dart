import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/model/momList_response_model.dart';

MeetingMom meetingMomFromJson(String str) => MeetingMom.fromJson(json.decode(str));

String meetingMomToJson(MeetingMom data) => json.encode(data.toJson());

class MeetingMom {
  final bool success;
  final List<MeetingMomDatum> data;
  final int totalCount;

  MeetingMom({
    required this.success,
    required this.data,
    required this.totalCount,
  });

  factory MeetingMom.fromJson(Map<String, dynamic> json) => MeetingMom(
    success: json["success"],
    data: List<MeetingMomDatum>.from(json["data"].map((x) => MeetingMomDatum.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class MeetingMomDatum {
  final String meetingId;
  final String meetingMom;
  final String meetingDate;
  final String remarks;
  final String createdBy;
  final String checkIn;
  final String checkOut;
  final String custnm;
  final int totalCount;
  final MultiSelectController<MomListDatum> controller;
  RxList<MomListDatum> selectedMOM;
  RxBool isLoading = false.obs;
  Rx<TextEditingController> remarksController;

  MeetingMomDatum({
    required this.meetingId,
    required this.meetingMom,
    required this.meetingDate,
    required this.remarks,
    required this.createdBy,
    required this.checkIn,
    required this.checkOut,
    required this.custnm,
    required this.totalCount,
    required this.controller,
    required this.selectedMOM,
    required this.isLoading,
    required this.remarksController
  });

  factory MeetingMomDatum.fromJson(Map<String, dynamic> json) => MeetingMomDatum(
    meetingId: json["meetingId"] ?? '',
    meetingMom: json["meetingMOM"] ?? '',
    meetingDate: json["meetingDate"] ?? '',
    remarks: json["remarks"] ?? '',
    createdBy: json["createdBy"] ?? '',
    checkIn: json["checkIn"] ?? '',
    checkOut: json["checkOut"] ?? '',
    custnm: json["custnm"] ?? '',
    totalCount: json["totalCount"] ?? 0,
    controller: json['controller'] ?? MultiSelectController(),
    selectedMOM: json['selectedMOM'] ?? [MomListDatum()].obs,
    isLoading: json["isLoading"] ?? false.obs,
    remarksController: TextEditingController(text: json["isLoading"] ?? "").obs
  );

  Map<String, dynamic> toJson() => {
    "meetingId": meetingId,
    "meetingMOM": meetingMom,
    "meetingDate": meetingDate,
    "remarks": remarks,
    "createdBy": createdBy,
    "checkIn": checkIn,
    "checkOut": checkOut,
    "custnm": custnm,
    "totalCount": totalCount,
    "controller" : controller,
    "selectedMOM" : selectedMOM,
    "isLoading" : isLoading.value,
    "remarksController" : remarksController.value
  };
}
