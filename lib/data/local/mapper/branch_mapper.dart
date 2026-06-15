import '../../../modules/lead/add_lead/model/get_branch_response_model.dart';
import '../entity/dropdown_entity.dart';

extension BranchMapper on Branch {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "BRANCH",
      value: locCode,
      label: locName,
    );
  }
}
