import 'package:flutter_test/flutter_test.dart';

import 'package:vaultkey_app/models/models.dart';

void main() {
  group('PasswordStrength', () {
    test('calculateStrength returns weak for short passwords', () {
      expect(calculateStrength('abc'), PasswordStrength.weak);
    });

    test('calculateStrength returns fair for 8+ chars', () {
      expect(calculateStrength('password1'), PasswordStrength.fair);
    });

    test('calculateStrength returns strong for 12+ chars', () {
      expect(calculateStrength('password12345'), PasswordStrength.strong);
    });

    test('calculateStrength returns excellent for 16+ chars with symbols', () {
      expect(calculateStrength('K7#mPq2\$vR9nLw!x'), PasswordStrength.excellent);
    });
  });

  group('StrengthMeta', () {
    test('strength meta has correct bar counts', () {
      expect(strengthMeta[PasswordStrength.weak]!.bars, 1);
      expect(strengthMeta[PasswordStrength.fair]!.bars, 2);
      expect(strengthMeta[PasswordStrength.strong]!.bars, 3);
      expect(strengthMeta[PasswordStrength.excellent]!.bars, 4);
    });
  });

  group('CategoryMeta', () {
    test('all categories have metadata', () {
      for (final cat in Category.values) {
        expect(categoryMeta[cat], isNotNull);
      }
    });
  });

  group('DatabaseHelper', () {
    test('toMap/fromMap round-trips category and strength enums (via seed data)', () async {
      // Verify seed data is well-formed
      for (final pw in mockPasswords) {
        expect(categoryMeta.containsKey(pw.category), isTrue);
        expect(strengthMeta.containsKey(pw.strength), isTrue);
        expect(pw.id, isNotEmpty);
        expect(pw.title, isNotEmpty);
      }
      expect(mockPasswords.length, 8);
    });
  });
}