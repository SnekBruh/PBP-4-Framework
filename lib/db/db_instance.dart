import 'package:sqflite/sqflite.dart';

class DbInstance {
  static Future<void> createTables(Database database) async {
    await database.execute("""
  CREATE TABLE ruangan(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nama_ruangan TEXT,
    kapasitas TEXT,
    kode_ruangan TEXT
  )
  """);
  }

  static Future<Database> database() async {
    return openDatabase('ruangan.db', version: 1,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> addRuangan(
      String kode, String nama_ruangan, String kapasitas) async {
    final db = await DbInstance.database();
    final data = {
      'kode_ruangan': kode,
      'nama_ruangan': nama_ruangan,
      'kapasitas': kapasitas,
    };
    return await db.insert('ruangan', data);
  }

  static Future<List<Map<String, dynamic>>> getRuangan() async {
    final db = await DbInstance.database();
    return db.query('ruangan');
  }

  static Future<int> editRuangan(
      int id, String kode, String nama_ruangan, String kapasitas) async {
    final db = await DbInstance.database();
    final data = {
      'kode_ruangan': kode,
      'nama_ruangan': nama_ruangan,
      'kapasitas': kapasitas
    };
    return await db.update('ruangan', data, where: "id = $id");
  }

  static Future<void> deleteRuangan(int id) async {
    final db = await DbInstance.database();
    await db.delete('ruangan', where: "id = $id");
  }
}
