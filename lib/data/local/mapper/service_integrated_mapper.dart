import '../../../modules/lead/add_lead/model/get_service_integrated_responce_model.dart';
import '../entity/dropdown_entity.dart';

extension ServiceMapper on Service {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "SERVICE_INTEGRATED",
      value: codeId,
      label: codeDesc,
    );
  }
}
