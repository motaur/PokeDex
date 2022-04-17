// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorDataBase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DataBaseBuilder databaseBuilder(String name) =>
      _$DataBaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DataBaseBuilder inMemoryDatabaseBuilder() => _$DataBaseBuilder(null);
}

class _$DataBaseBuilder {
  _$DataBaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DataBaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DataBaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DataBase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DataBase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DataBase extends DataBase {
  _$DataBase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GalleryDao? _galleryDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `GalleryEntity` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `nickName` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GalleryDao get galleryDao {
    return _galleryDaoInstance ??= _$GalleryDao(database, changeListener);
  }
}

class _$GalleryDao extends GalleryDao {
  _$GalleryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _galleryEntityInsertionAdapter = InsertionAdapter(
            database,
            'GalleryEntity',
            (GalleryEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nickName': item.nickName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GalleryEntity> _galleryEntityInsertionAdapter;

  @override
  Future<List<GalleryEntity>?> getAllData() async {
    return _queryAdapter.queryList('SELECT * FROM GalleryEntity',
        mapper: (Map<String, Object?> row) => GalleryEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            nickName: row['nickName'] as String));
  }

  @override
  Future<GalleryEntity?> deleteData(String id) async {
    return _queryAdapter.query('DELETE FROM GalleryEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => GalleryEntity(
            id: row['id'] as String,
            name: row['name'] as String,
            nickName: row['nickName'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertData(GalleryEntity galleryEntity) async {
    await _galleryEntityInsertionAdapter.insert(
        galleryEntity, OnConflictStrategy.replace);
  }
}
