import '../../../modules/lead/add_lead/model/get_user_response_model.dart';
import '../entity/dropdown_entity.dart';

extension AssignedUserMapper on AssignedUser {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "ASSIGNED_USER",
      value: userId,
      label: name,
    );
  }
}
