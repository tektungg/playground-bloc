import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReimbursementDatabaseHelper {
  static final ReimbursementDatabaseHelper _instance =
      ReimbursementDatabaseHelper._internal();
  static Database? _database;

  ReimbursementDatabaseHelper._internal();

  factory ReimbursementDatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reimbursements.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reimbursements(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        claimType TEXT NOT NULL,
        detail TEXT NOT NULL,
        attachments TEXT NOT NULL,
        approvalLines TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'submitted',
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
