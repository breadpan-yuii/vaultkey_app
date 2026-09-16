import 'package:flutter/foundation.dart' hide Category;
import '../models/models.dart' show PasswordEntry, PasswordStrength, Category, mockPasswords;
import '../database/database_helper.dart';

class PasswordProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<PasswordEntry> _passwords = [];
  bool _isLoading = false;

  List<PasswordEntry> get passwords => _passwords;
  bool get isLoading => _isLoading;

  Future<void> loadPasswords() async {
    _isLoading = true;
    notifyListeners();
    _passwords = await _db.getAllPasswords();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPassword(PasswordEntry pw) async {
    await _db.insertPassword(pw);
    await loadPasswords();
  }

  Future<void> updatePassword(PasswordEntry pw) async {
    await _db.updatePassword(pw);
    await loadPasswords();
  }

  Future<void> deletePassword(int id) async {
    await _db.deletePassword(id);
    await loadPasswords();
  }

  Future<void> toggleFavorite(PasswordEntry pw) async {
    final updated = PasswordEntry(
      id: pw.id,
      title: pw.title,
      username: pw.username,
      password: pw.password,
      website: pw.website,
      category: pw.category,
      strength: pw.strength,
      lastUpdated: pw.lastUpdated,
      favorite: !pw.favorite,
      notes: pw.notes,
    );
    await _db.updatePassword(updated);
    await loadPasswords();
  }

  int get totalCount => _passwords.length;
  int get weakCount => _passwords.where((p) => p.strength == PasswordStrength.weak).length;
  int get categoryCount => _passwords.map((p) => p.category).toSet().length;
  List<PasswordEntry> get favorites => _passwords.where((p) => p.favorite).toList();
  List<PasswordEntry> get recent => _passwords.take(4).toList();

  int get securityScore {
    if (_passwords.isEmpty) return 0;
    int score = 0;
    for (final pw in _passwords) {
      switch (pw.strength) {
        case PasswordStrength.excellent:
          score += 100;
          break;
        case PasswordStrength.strong:
          score += 75;
          break;
        case PasswordStrength.fair:
          score += 50;
          break;
        case PasswordStrength.weak:
          score += 25;
          break;
      }
    }
    return (score / _passwords.length).round();
  }

  List<PasswordEntry> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return _passwords.where((p) =>
      p.title.toLowerCase().contains(q) ||
      p.username.toLowerCase().contains(q) ||
      p.website.toLowerCase().contains(q) ||
      p.notes.toLowerCase().contains(q)
    ).toList();
  }

  List<PasswordEntry> filterByCategory(Category? category) {
    if (category == null) return _passwords;
    return _passwords.where((p) => p.category == category).toList();
  }

  Future<void> seedIfEmpty() async {
    await loadPasswords();
    if (_passwords.isEmpty) {
      for (final pw in mockPasswords) {
        await _db.insertPassword(pw);
      }
      await loadPasswords();
    }
  }
}
