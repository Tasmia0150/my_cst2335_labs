import 'dart:async';
import 'package:floor/floor.dart';
import 'entity/shopping_item.dart';
import 'dao/shopping_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 2, entities: [ShoppingItem])
abstract class ShoppingDatabase extends FloorDatabase {
  ShoppingDao get shoppingDao;  // Make sure this matches your DAO name
}