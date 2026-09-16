import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:vaultkey_app/models/models.dart';
import 'package:vaultkey_app/database/database_helper.dart';
import 'package:vaultkey_app/providers/password_provider.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() {
    DatabaseHelper.dbDirectoryOverride = null;
  });

  test('full CRUD cycle against a real SQLite database', () async {
    final dir = await Directory.systemTemp.createTemp('vaultkey_crud');
    DatabaseHelper.dbDirectoryOverride = dir.path;
    print('STEP 0: temp dir created: ${dir.path}');
    expect(dir.existsSync(), isTrue);
    print('STEP 0b: exists true');

    final provider = PasswordProvider();
    print('STEP 1: provider created');
    expect(provider.totalCount, 0);

    // CREATE
    final entry = PasswordEntry(
      id: '0',
      title: 'TestBank',
      username: 'user@test.com',
      password: 'P@ssw0rd!xY',
      website: 'testbank.com',
      category: Category.banking,
      strength: calculateStrength('P@ssw0rd!xY'),
      lastUpdated: 'Just now',
      notes: 'integration test',
    );
    print('STEP 2: calling addPassword...');
    await provider.addPassword(entry);
    print('STEP 3: addPassword done');
    expect(provider.totalCount, 1);
    expect(provider.passwords.first.title, 'TestBank');
    expect(provider.passwords.first.id, isNot('0'), reason: 'DB must assign a real id');

    // READ
    final db = DatabaseHelper.instance;
    final fromDb = await db.getPassword(int.parse(provider.passwords.first.id));
    expect(fromDb, isNotNull);
    expect(fromDb!.username, 'user@test.com');
    expect(fromDb.category, Category.banking);

    // UPDATE
    final updated = PasswordEntry(
      id: provider.passwords.first.id,
      title: 'TestBank Renamed',
      username: 'new@test.com',
      password: 'NewP@ss!2026!',
      website: 'testbank.io',
      category: Category.work,
      strength: calculateStrength('NewP@ss!2026!'),
      lastUpdated: 'Just now',
      favorite: true,
      notes: 'updated note',
    );
    await provider.updatePassword(updated);
    expect(provider.totalCount, 1);
    expect(provider.passwords.first.title, 'TestBank Renamed');
    expect(provider.passwords.first.category, Category.work);
    expect(provider.passwords.first.favorite, isTrue);

    // DELETE
    await provider.deletePassword(int.parse(provider.passwords.first.id));
    expect(provider.totalCount, 0);

    dir.deleteSync(recursive: true);
  });
}