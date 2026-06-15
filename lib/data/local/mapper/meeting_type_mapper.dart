import '../../../modules/my_call/add_my_call_screen/call_module_response_model.dart';
import '../entity/dropdown_entity.dart';

extension MeetingTypeMapper on CallType {
  DropdownEntity toDropdown() {
    return DropdownEntity(type: "MEETING_TYPE", value: codeId, label: codeDesc);
  }
}
