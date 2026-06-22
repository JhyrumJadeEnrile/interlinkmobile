import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'internlink.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Attendance Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        userName TEXT NOT NULL,
        userRole TEXT NOT NULL,
        timeIn TEXT NOT NULL,
        timeOut TEXT,
        date TEXT NOT NULL,
        location TEXT,
        totalHours REAL,
        status TEXT DEFAULT 'Pending',
        remarks TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Timesheets Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS timesheets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        userName TEXT NOT NULL,
        userRole TEXT NOT NULL,
        weekStart TEXT NOT NULL,
        weekEnd TEXT NOT NULL,
        totalHours REAL,
        status TEXT DEFAULT 'Draft',
        approverName TEXT,
        approvalDate TEXT,
        remarks TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Users Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        role TEXT NOT NULL,
        company TEXT,
        department TEXT,
        position TEXT,
        phoneNumber TEXT,
        profileImage TEXT,
        biometricEnabled INTEGER DEFAULT 0,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Approvals Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS approvals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timesheetId INTEGER NOT NULL,
        requestorName TEXT NOT NULL,
        requestorRole TEXT NOT NULL,
        submittedDate TEXT NOT NULL,
        approverName TEXT,
        approvalDate TEXT,
        status TEXT DEFAULT 'Pending',
        remarks TEXT,
        FOREIGN KEY (timesheetId) REFERENCES timesheets(id)
      )
    ''');

    // Reports Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reportType TEXT NOT NULL,
        generatedBy TEXT NOT NULL,
        generatedDate TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        totalRecords INTEGER,
        fileUrl TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Notifications Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT,
        isRead INTEGER DEFAULT 0,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Seed test users
    await _seedTestUsers(db);
  }

  Future<void> _seedTestUsers(Database db) async {
    final testUsers = [
      {
        'email': 'natnat@example.com',
        'password': 'password',
        'fullName': 'Natnat Garcia',
        'role': 'student',
        'company': 'Tech Solutions Inc.',
        'department': 'IT',
        'position': 'OJT Student',
        'phoneNumber': '09123456789',
      },
      {
        'email': 'fernando@example.com',
        'password': 'password',
        'fullName': 'Fernando Santos',
        'role': 'teacher',
        'company': 'Education Hub',
        'department': 'Training',
        'position': 'Instructor',
        'phoneNumber': '09987654321',
      },
      {
        'email': 'maria@example.com',
        'password': 'password',
        'fullName': 'Maria Reyes',
        'role': 'supervisor',
        'company': 'Management Office',
        'department': 'HR',
        'position': 'Supervisor',
        'phoneNumber': '09567891234',
      },
      {
        'email': 'admin@example.com',
        'password': 'password',
        'fullName': 'Admin User',
        'role': 'admin',
        'company': 'System Administration',
        'department': 'Admin',
        'position': 'Administrator',
        'phoneNumber': '09111111111',
      },
    ];

    for (final user in testUsers) {
      await db.insert('users', user);
    }
  }

  // Attendance Methods
  Future<int> addAttendance(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('attendance', data);
  }

  Future<List<Map<String, dynamic>>> getAttendanceByUser(String userId) async {
    final db = await database;
    return await db.query(
      'attendance',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  Future<int> updateAttendance(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'attendance',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Timesheet Methods
  Future<int> addTimesheet(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('timesheets', data);
  }

  Future<List<Map<String, dynamic>>> getTimesheetsByUser(String userId) async {
    final db = await database;
    return await db.query(
      'timesheets',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'weekStart DESC',
    );
  }

  Future<int> updateTimesheet(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'timesheets',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User Methods
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(String email, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'users',
      data,
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Approval Methods
  Future<int> addApproval(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('approvals', data);
  }

  Future<List<Map<String, dynamic>>> getPendingApprovalsForSupervisor(
      String supervisorName) async {
    final db = await database;
    return await db.query(
      'approvals',
      where: 'status = ? AND approverName IS NULL',
      whereArgs: ['Pending'],
      orderBy: 'submittedDate DESC',
    );
  }

  // General Methods
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
