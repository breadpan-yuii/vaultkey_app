import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HelpScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const HelpScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      ('How is my data encrypted?', 'VaultKey uses AES-256 encryption. Your master password is hashed locally and never stored on our servers.'),
      ('What if I forget my master password?', 'We cannot recover it for you — this is by design. Store your master password in a secure offline location.'),
      ('Can I sync across devices?', 'Yes! Enable Cloud Sync in Settings to securely sync your vault across all your devices.'),
      ('How do I import passwords?', 'Go to Settings > Export/Import and select a CSV from your browser or another password manager.'),
    ];

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Help & Support',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Text('💬', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contact Support',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            Text(
                              'support@vaultkey.app',
                              style: TextStyle(color: AppColors.textMuted.withOpacity(0.45), fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // FAQs
                  Text(
                    'FAQS',
                    style: TextStyle(
                      color: AppColors.textMuted.withOpacity(0.45),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...faqs.map((faq) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faq.$1,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          faq.$2,
                          style: TextStyle(color: AppColors.textMuted.withOpacity(0.5), fontSize: 13, height: 1.6),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
