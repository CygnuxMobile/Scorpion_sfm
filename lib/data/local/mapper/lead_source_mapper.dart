import '../../../modules/lead/add_lead/model/get_lead_source_responce_model.dart';
import '../entity/dropdown_entity.dart';

extension LeadSourceMapper on LeadSource {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "LEADSRC",
      value: codeId,
      label: codeDesc,
    );
  }
}
