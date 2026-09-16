import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/password_provider.dart';
import '../models/models.dart';

class NotificationsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const NotificationsScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, provider, _) {
        final notifications = _buildNotifications(provider);

        return Container(
          color: AppColors.background,
          child: Column(
            children: [
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
                    const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text('No notifications', style: TextStyle(color: AppColors.textMuted.withOpacity(0.5), fontSize: 15)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        itemCount: notifications.length,
                        itemBuilder: (context, i) {
                          final n = notifications[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: n.color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(n.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
                                          Text(n.time, style: TextStyle(color: AppColors.textMuted.withOpacity(0.3), fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(n.body, style: TextStyle(color: AppColors.textMuted.withOpacity(0.55), fontSize: 13, height: 1.5)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<({String title, String body, String time, Color color})> _buildNotifications(PasswordProvider provider) {
    final list = <({String title, String body, String time, Color color})>[];

    for (final pw in provider.passwords) {
      if (pw.strength == PasswordStrength.weak) {
        list.add((
          title: 'Weak Password Detected',
          body: '${pw.title} password is too weak. Update it now.',
          time: 'Now',
          color: AppColors.error,
        ));
      }
      if (pw.lastUpdated.contains('month')) {
        list.add((
          title: 'Password Age Alert',
          body: '${pw.title} password hasn\'t been updated in 30+ days.',
          time: 'Today',
          color: AppColors.warning,
        ));
      }
    }

    final usedPasswords = <String, int>{};
    for (final pw in provider.passwords) {
      usedPasswords[pw.password] = (usedPasswords[pw.password] ?? 0) + 1;
    }
    for (final entry in usedPasswords.entries) {
      if (entry.value > 1 && entry.key.isNotEmpty) {
        final titles = provider.passwords.where((p) => p.password == entry.key).map((p) => p.title).take(2).join(' and ');
        list.add((
          title: 'Duplicate Password',
          body: '$titles share the same password.',
          time: 'Today',
          color: AppColors.strengthStrong,
        ));
      }
    }

    if (list.isEmpty) {
      list.add((
        title: 'Vault Backup Complete',
        body: 'Your vault was successfully backed up to the cloud.',
        time: '1d ago',
        color: AppColors.success,
      ));
    }

    return list;
  }
}