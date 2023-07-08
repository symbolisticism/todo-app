import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/models/todo_item.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'items.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE items(id TEXT PRIMARY KEY, done BOOLEAN, description TEXT)');
    },
    version: 1,
  );

  return db;
}

class ItemsNotifier extends StateNotifier<List<TodoItem>> {
  ItemsNotifier() : super(const []);

  Future<void> loadItems({bool ascending = true}) async {
    final db = await _getDatabase();

    final List<Map<String, Object?>> data;

    if (ascending) {
      data = await db.query('items');
    } else {
      data = await db.query('items', orderBy: 'id DESC');
    }

    final places = data
        .map(
          (row) => TodoItem(
            id: row['id'] as String,
            done: row['done'] as bool,
            description: row['description'] as String,
          ),
        )
        .toList();

    state = places;
  }

  void addItem(String description) async {
    final newItem = TodoItem(
      id: DateTime.now().toString(),
      done: false,
      description: description,
    );

    final db = await _getDatabase();

    db.insert(
      'items',
      {
        'id': newItem.id,
        'done': newItem.done,
        'description': newItem.description,
      },
    );

    state = [newItem, ...state];
  }

  Future<int> removeItem(String id) async {
    final db = await _getDatabase();

    int count =
        await db.delete('items', where: 'id = ?', whereArgs: [id]);

    return count; 
  }
}

final itemsProvider = StateNotifierProvider<ItemsNotifier, List<TodoItem>>(
    (ref) => ItemsNotifier());
