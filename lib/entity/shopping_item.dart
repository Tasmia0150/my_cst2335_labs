import 'package:floor/floor.dart';

@Entity(tableName: 'ShoppingItem')
class ShoppingItem {
  @PrimaryKey(autoGenerate: true) // Capital "P" in PrimaryKey
  final int? id;

  final String name;
  final int quantity;

  ShoppingItem({this.id, required this.name, required this.quantity});
}