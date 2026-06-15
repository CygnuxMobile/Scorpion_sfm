import 'dart:convert';
import '../main.dart';
import '../modules/lead/add_lead/model/get_category_response_model.dart';


class LocalStorageKey {
  static String token = "token";
  static String isPunchIn = "isPunchIn";
  static String isPunchOut = "isPunchOut";
  static String userId = "userId";
  static String userName = "userName";
  static String brcd = "brcd";
  static String isDelete = "isDelete";
  static String deletedUserId = "deletedUserId";
  static String branchName = "branchName";
  static String designation = "designation";
  static String designationId = "designationId";
  static String branchCode = "branchCode";
  static String regionName = "regionName";
  static String regionCode = "regionCode";
  static String isGetMenu = "isGetMenu";
  static String isAllMenu = "isAllMenu";
  static String isComplainMenu = "isComplainMenu";
  static String categoryList = "categoryList";
}

class Pref {
  static String? getToken() {
    // debugPrint("Token === ${pref!.getString(LocalStorageKey.token)}");
    return pref!.getString(LocalStorageKey.token);
  }

  static String? getUserId() {
    return pref!.getString(LocalStorageKey.userId);
  }

  static bool? getPunchIn() {
    return pref!.getBool(LocalStorageKey.isPunchIn);
  }

  static bool? getPunchOut() {
    return pref!.getBool(LocalStorageKey.isPunchOut);
  }

  static String? getUserName() {
    return pref!.getString(LocalStorageKey.userName);
  }

  static String? getBranchName() {
    return pref!.getString(LocalStorageKey.branchName);
  }

  static String? getBranchCode() {
    return pref!.getString(LocalStorageKey.branchCode);
  }

  static String? getDesignationName() {
    return pref!.getString(LocalStorageKey.designation);
  }

  static String? getDesignationId() {
    return pref!.getString(LocalStorageKey.designationId);
  }

  static String? getRegionName() {
    return pref!.getString(LocalStorageKey.regionName);
  }

  static String? getRegionCode() {
    return pref!.getString(LocalStorageKey.regionCode);
  }

  static String? getBrcd() {
    return pref!.getString(LocalStorageKey.brcd);
  }

  static bool? getIsMenu() {
    return pref!.getBool(LocalStorageKey.isGetMenu);
  }

  static bool? getIsAllMenu() {
    return pref!.getBool(LocalStorageKey.isAllMenu);
  }

  static bool? getIsComplainMenu() {
    return pref!.getBool(LocalStorageKey.isComplainMenu);
  }

  static Future<List<Categories>?> getLeadCategory() async {
    final jsonString = pref!.getString(LocalStorageKey.categoryList);
    if (jsonString == null) return null;

    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => Categories.fromJson(e)).toList();
  }
}
