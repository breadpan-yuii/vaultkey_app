import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../providers/password_provider.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<String>? onNav;
  final ValueChanged<PasswordEntry>? onDetail;

  const HomeScreen({super.key, this.onNav, this.onDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, provider, _) {
        final stats = [
          (
            label: 'Total Saved',
            value: '${provider.totalCount}',
            color: AppColors.primary,
            icon: Icons.lock_rounded,
          ),
          (
            label: 'Weak',
            value: '${provider.weakCount}',
            color: AppColors.error,
            icon: Icons.warning_rounded,
          ),
          (
            label: 'Categories',
            value: '${provider.categoryCount}',
            color: AppColors.social,
            icon: Icons.key_rounded,
          ),
        ];

        final recent = provider.recent;
        final score = provider.securityScore;

        final alerts = <({String msg, Color color})>[];
        for (final pw in provider.passwords) {
          if (pw.strength == PasswordStrength.weak) {
            alerts.add((
              msg: '${pw.title} password is weak',
              color: AppColors.warning,
            ));
          }
          if (pw.lastUpdated.contains('month')) {
            alerts.add((
              msg: '${pw.title} password not updated in 30+ days',
              color: AppColors.strengthStrong,
            ));
          }
        }

        return Container(
          color: AppColors.background,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.header,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning,',
                                style: TextStyle(
                                  color: AppColors.textMuted.withValues(
                                    alpha: 0.45,
                                  ),
                                  fontSize: 13,
                                ),
                              ),
                              const Text(
                                'Alex Morgan 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildIconButton(
                                Icons.search_rounded,
                                () => onNav?.call('search'),
                              ),
                              const SizedBox(width: 10),
                              _buildIconButtonWithBadge(
                                Icons.notifications_rounded,
                                () => onNav?.call('notifications'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 52,
                              height: 52,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: score / 100,
                                    strokeWidth: 5,
                                    backgroundColor: AppColors.primary
                                        .withValues(alpha: 0.15),
                                    valueColor: const AlwaysStoppedAnimation(
                                      AppColors.primary,
                                    ),
                                    strokeCap: StrokeCap.round,
                                  ),
                                  Text(
                                    '$score',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Security Score',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        score >= 75
                                            ? 'Good'
                                            : score >= 50
                                            ? 'Fair'
                                            : 'Poor',
                                        style: TextStyle(
                                          color: score >= 75
                                              ? AppColors.strengthExcellent
                                              : score >= 50
                                              ? AppColors.strengthStrong
                                              : AppColors.strengthWeak,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${provider.weakCount} weak password${provider.weakCount != 1 ? 's' : ''} need attention',
                                    style: TextStyle(
                                      color: AppColors.textMuted.withValues(
                                        alpha: 0.45,
                                      ),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: stats
                            .map(
                              (s) => Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(s.icon, color: s.color, size: 18),
                                      const SizedBox(height: 8),
                                      Text(
                                        s.value,
                                        style: TextStyle(
                                          color: s.color,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'JetBrains Mono',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        s.label,
                                        style: TextStyle(
                                          color: AppColors.textMuted.withValues(
                                            alpha: 0.45,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      ...alerts.map(
                        (a) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: a.color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: a.color.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_rounded, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  a.msg,
                                  style: TextStyle(
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildQuickAction(
                              Icons.add_rounded,
                              'Add Password',
                              AppColors.primary,
                              () => onNav?.call('add'),
                            ),
                            const SizedBox(width: 10),
                            _buildQuickAction(
                              Icons.bolt_rounded,
                              'Generate',
                              AppColors.social,
                              () => onNav?.call('generator'),
                            ),
                            const SizedBox(width: 10),
                            _buildQuickAction(
                              Icons.search_rounded,
                              'Search',
                              AppColors.email,
                              () => onNav?.call('search'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onNav?.call('vault'),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...recent.map(
                        (pw) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PasswordCard(
                            pw: pw,
                            onTap: () => onDetail?.call(pw),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary.withValues(alpha: 0.7),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildIconButtonWithBadge(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Icon(
              icon,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
              size: 18,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
