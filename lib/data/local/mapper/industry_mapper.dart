import '../../../modules/lead/add_lead/model/get_industry_type_response_model.dart';
import '../entity/dropdown_entity.dart';

extension IndustryMapper on IndustryType {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "INDUSTRY",
      value: codeId,
      label: codeDesc,
    );
  }
}
