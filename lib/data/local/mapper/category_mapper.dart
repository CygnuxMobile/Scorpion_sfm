import '../../../modules/lead/add_lead/model/get_category_response_model.dart';
import '../entity/dropdown_entity.dart';

extension CategoryMapper on Categories {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "CATEGORY",
      value: codeId,
      label: codeDesc,
    );
  }
}
