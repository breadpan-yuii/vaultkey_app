import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum NavScreen { home, vault, generator, notifications, profile }

class BottomNav extends StatelessWidget {
  final NavScreen active;
  final ValueChanged<NavScreen> onTap;

  const BottomNav({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (NavScreen.home, Icons.home_rounded, 'Home'),
      (NavScreen.vault, Icons.grid_view_rounded, 'Vault'),
      (NavScreen.generator, Icons.bolt_rounded, 'Generate'),
      (NavScreen.notifications, Icons.notifications_rounded, 'Alerts'),
      (NavScreen.profile, Icons.person_rounded, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95),
        border: const Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              final (screen, icon, label) = item;
              final isActive = active == screen;
              return GestureDetector(
                onTap: () => onTap(screen),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isActive ? AppColors.primary : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isActive ? AppColors.primary : AppColors.textMuted,
                        letterSpacing: 0.03,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
