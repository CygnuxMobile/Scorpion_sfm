import '../../../modules/lead/add_lead/model/get_user_response_model.dart';
import '../entity/dropdown_entity.dart';


extension UserMapper on User {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "USER",
      value: userId,
      label: name,
    );
  }
}
