import '../../../modules/lead/add_lead/model/get_city_response_model.dart';
import '../entity/dropdown_entity.dart';

extension CityMapper on City {
  DropdownEntity toDropdown() {
    return DropdownEntity(
      type: "CITY",
      value: cityCode.toString(),
      label: location,
    );
  }
}
