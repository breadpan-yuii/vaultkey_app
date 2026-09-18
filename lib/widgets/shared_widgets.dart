import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';

String maskPassword(String pw) => '•' * pw.length;

String generateRandomPassword({
  int length = 16,
  bool useUpper = true,
  bool useNumbers = true,
  bool useSymbols = true,
}) {
  String chars = 'abcdefghijklmnopqrstuvwxyz';
  if (useUpper) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  if (useNumbers) chars += '0123456789';
  if (useSymbols) chars += '!@#\$%^&*';
  final rng = Random.secure();
  return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
}

void copyToClipboard(BuildContext context, String label, String value) {
  Clipboard.setData(ClipboardData(text: value));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$label copied to clipboard'),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ),
  );
}

class StrengthBars extends StatelessWidget {
  final PasswordStrength level;
  final bool showLabel;

  const StrengthBars({super.key, required this.level, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final meta = strengthMeta[level]!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          4,
          (i) => Container(
            width: 20,
            height: 4,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: i < meta.bars ? meta.color : AppColors.cardBorder,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            meta.label,
            style: TextStyle(
              fontSize: 11,
              color: meta.color,
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final Category cat;
  const CategoryChip({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final m = categoryMeta[cat]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: m.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(m.icon, size: 12, color: m.color),
          const SizedBox(width: 4),
          Text(
            m.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: m.color,
              letterSpacing: 0.02,
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordCard extends StatelessWidget {
  final PasswordEntry pw;
  final VoidCallback? onTap;

  const PasswordCard({super.key, required this.pw, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cat = categoryMeta[pw.category]!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cat.bg,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Icon(cat.icon, color: cat.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          pw.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (pw.favorite) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.star, color: AppColors.work, size: 13),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pw.username.length > 22
                        ? '${pw.username.substring(0, 22)}…'
                        : pw.username,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: strengthMeta[pw.strength]!.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pw.lastUpdated,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
