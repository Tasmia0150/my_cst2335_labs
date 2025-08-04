// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ShoppingDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ShoppingDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ShoppingDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ShoppingDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorShoppingDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ShoppingDatabaseBuilderContract databaseBuilder(String name) =>
      _$ShoppingDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ShoppingDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ShoppingDatabaseBuilder(null);
}

class _$ShoppingDatabaseBuilder implements $ShoppingDatabaseBuilderContract {
  _$ShoppingDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ShoppingDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ShoppingDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ShoppingDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ShoppingDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ShoppingDatabase extends ShoppingDatabase {
  _$ShoppingDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ShoppingDao? _shoppingDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ShoppingItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `quantity` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ShoppingDao get shoppingDao {
    return _shoppingDaoInstance ??= _$ShoppingDao(database, changeListener);
  }
}

class _$ShoppingDao extends ShoppingDao {
  _$ShoppingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _shoppingItemInsertionAdapter = InsertionAdapter(
            database,
            'ShoppingItem',
            (ShoppingItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _shoppingItemDeletionAdapter = DeletionAdapter(
            database,
            'ShoppingItem',
            ['id'],
            (ShoppingItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ShoppingItem> _shoppingItemInsertionAdapter;

  final DeletionAdapter<ShoppingItem> _shoppingItemDeletionAdapter;

  @override
  Future<List<ShoppingItem>> findAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM ShoppingItem',
        mapper: (Map<String, Object?> row) => ShoppingItem(
            id: row['id'] as int?,
            name: row['name'] as String,
            quantity: row['quantity'] as int));
  }

  @override
  Future<void> insertItem(ShoppingItem item) async {
    await _shoppingItemInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(ShoppingItem item) async {
    await _shoppingItemDeletionAdapter.delete(item);
  }
}
