import 'package:floor/floor.dart';
import '../entity/shopping_item.dart';


@dao
abstract class ShoppingDao {
  @Query('SELECT * FROM ShoppingItem')
  Future<List<ShoppingItem>> findAllItems();

  @insert
  Future<void> insertItem(ShoppingItem item);

  @delete
  Future<void> deleteItem(ShoppingItem item);
}