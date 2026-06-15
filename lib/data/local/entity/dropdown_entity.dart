import 'package:objectbox/objectbox.dart';

@Entity()
class DropdownEntity {
  @Id()
  int id;

  String type;
  String value;
  String label;

  DropdownEntity({
    this.id = 0,
    required this.type,
    required this.value,
    required this.label,
  });
}
