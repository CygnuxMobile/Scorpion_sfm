import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';
import 'entity/dropdown_entity.dart';

class DropdownLocalDB {
  final Box<DropdownEntity> box;

  DropdownLocalDB(Store store) : box = store.box<DropdownEntity>();

  /// SAVE
  void save(String type, List<DropdownEntity> list) {
    final ids = box
        .query(DropdownEntity_.type.equals(type))
        .build()
        .findIds();

    box.removeMany(ids);
    box.putMany(list);
  }

  /// GET
  List<DropdownEntity> get(String type) {
    return box
        .query(DropdownEntity_.type.equals(type))
        .build()
        .find();
  }
}
