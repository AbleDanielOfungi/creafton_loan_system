import 'package:path/path.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();

    return _database!;
  }

  static Future<Database> _initialize() async {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;

    final dbPath = await databaseFactory.getDatabasesPath();

    final db = await databaseFactory.openDatabase(
      join(dbPath, "creafton_financial.db"),

      options: OpenDatabaseOptions(
        version: 2,

        onCreate: _createTables,

        onUpgrade: _upgradeDatabase,
      ),
    );

    await db.execute("PRAGMA foreign_keys = ON");

    await db.execute("PRAGMA journal_mode=WAL");

    return db;
  }

  static Future<void> _createTables(Database db, int version) async {
    // ROLES

    await db.execute('''

CREATE TABLE roles(

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL UNIQUE

)

''');

    // USERS

    await db.execute('''

CREATE TABLE users(

id INTEGER PRIMARY KEY AUTOINCREMENT,

username TEXT NOT NULL UNIQUE,

password TEXT NOT NULL,

full_name TEXT NOT NULL,

phone TEXT,

role_id INTEGER,

status INTEGER DEFAULT 1,

created_at TEXT,


FOREIGN KEY(role_id)

REFERENCES roles(id)

)

''');

    // BUSINESS SETTINGS

    await db.execute('''

CREATE TABLE business_settings(

id INTEGER PRIMARY KEY AUTOINCREMENT,

business_name TEXT,

currency TEXT DEFAULT 'UGX',

phone TEXT,

email TEXT,

address TEXT,

logo TEXT

)

''');

    // AUDIT LOGS

    await db.execute('''

CREATE TABLE audit_logs(

id INTEGER PRIMARY KEY AUTOINCREMENT,

user_id INTEGER,

action TEXT,

description TEXT,

created_at TEXT

)

''');

    // FIELD OFFICERS

    await db.execute('''

CREATE TABLE field_officers(

id INTEGER PRIMARY KEY AUTOINCREMENT,

officer_number TEXT UNIQUE NOT NULL,

full_name TEXT NOT NULL,

phone TEXT NOT NULL,

national_id TEXT,

district TEXT,

address TEXT,

status TEXT DEFAULT 'ACTIVE',

created_at TEXT

)

''');

    // BORROWERS

    await db.execute('''

CREATE TABLE borrowers(

id INTEGER PRIMARY KEY AUTOINCREMENT,


borrower_number TEXT UNIQUE NOT NULL,


full_name TEXT NOT NULL,


gender TEXT,


date_of_birth TEXT,


national_id TEXT,


phone TEXT NOT NULL,


alternative_phone TEXT,


email TEXT,


district TEXT,


village TEXT,


address TEXT,


occupation TEXT,


business_details TEXT,


photo TEXT,


field_officer_id INTEGER,


next_payment_date TEXT,


notes TEXT,


status TEXT DEFAULT 'ACTIVE',


created_at TEXT,



FOREIGN KEY(field_officer_id)

REFERENCES field_officers(id)

)

''');

    // GUARANTORS

    await db.execute('''

CREATE TABLE guarantors(

id INTEGER PRIMARY KEY AUTOINCREMENT,


borrower_id INTEGER NOT NULL,


full_name TEXT NOT NULL,


relationship TEXT,


phone TEXT,


national_id TEXT,


address TEXT,


created_at TEXT,



FOREIGN KEY(borrower_id)

REFERENCES borrowers(id)

ON DELETE CASCADE

)

''');

    // BORROWER DOCUMENTS

    await db.execute('''

CREATE TABLE borrower_documents(

id INTEGER PRIMARY KEY AUTOINCREMENT,


borrower_id INTEGER,


document_name TEXT,


file_path TEXT,


uploaded_at TEXT,



FOREIGN KEY(borrower_id)

REFERENCES borrowers(id)

ON DELETE CASCADE

)

''');

    // LOANS

    await db.execute('''

CREATE TABLE loans(

id INTEGER PRIMARY KEY AUTOINCREMENT,


loan_number TEXT UNIQUE NOT NULL,


borrower_id INTEGER NOT NULL,


principal_amount REAL NOT NULL,


interest_rate REAL DEFAULT 20,


interest_amount REAL,


total_payable REAL,


remaining_balance REAL,


daily_payment_amount REAL,


loan_duration INTEGER,


payment_frequency TEXT DEFAULT 'DAILY',


start_date TEXT,


end_date TEXT,


status TEXT DEFAULT 'ACTIVE',


created_at TEXT,



FOREIGN KEY(borrower_id)

REFERENCES borrowers(id)

ON DELETE CASCADE

)

''');

    // LOAN PAYMENTS

    await db.execute('''
CREATE TABLE loan_payments(

id INTEGER PRIMARY KEY AUTOINCREMENT,

loan_id INTEGER NOT NULL,

payment_number INTEGER,

payment_type TEXT DEFAULT 'INSTALLMENT',

amount REAL NOT NULL,

due_date TEXT,

payment_date TEXT,

next_payment_date TEXT,

status TEXT DEFAULT 'PENDING',

received_by INTEGER,

notes TEXT,

created_at TEXT,


FOREIGN KEY(loan_id)

REFERENCES loans(id)

ON DELETE CASCADE

)

''');

    await db.execute('''

CREATE TABLE borrower_statistics(

id INTEGER PRIMARY KEY AUTOINCREMENT,

borrower_id INTEGER UNIQUE NOT NULL,

total_loans INTEGER DEFAULT 0,

active_loans INTEGER DEFAULT 0,

completed_loans INTEGER DEFAULT 0,

total_borrowed REAL DEFAULT 0,

total_paid REAL DEFAULT 0,

outstanding_balance REAL DEFAULT 0,

total_payments INTEGER DEFAULT 0,

late_payments INTEGER DEFAULT 0,

missed_payments INTEGER DEFAULT 0,

repayment_score REAL DEFAULT 0,

last_payment_date TEXT,

created_at TEXT,


FOREIGN KEY(borrower_id)

REFERENCES borrowers(id)

ON DELETE CASCADE

)

''');

    // FIELD OFFICER PERFORMANCE

    await db.execute('''

CREATE TABLE field_officer_performance(

id INTEGER PRIMARY KEY AUTOINCREMENT,


field_officer_id INTEGER UNIQUE,


total_assigned INTEGER DEFAULT 0,


active_loans INTEGER DEFAULT 0,


total_collected REAL DEFAULT 0,


outstanding_amount REAL DEFAULT 0,


recovery_rate REAL DEFAULT 0,


last_updated TEXT,



FOREIGN KEY(field_officer_id)

REFERENCES field_officers(id)

ON DELETE CASCADE

)

''');

    await _createIndexes(db);
  }

  static Future<void> _createIndexes(Database db) async {
    await db.execute('''

CREATE INDEX idx_borrower_name

ON borrowers(full_name)

''');

    await db.execute('''

CREATE INDEX idx_borrower_phone

ON borrowers(phone)

''');

    await db.execute('''

CREATE INDEX idx_payment_date

ON loan_payments(payment_date)

''');
  }

  static Future<void> _upgradeDatabase(
    Database db,

    int oldVersion,

    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createTables(db, newVersion);
    }
  }
}
