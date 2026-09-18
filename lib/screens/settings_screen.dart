import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const SettingsScreen({super.key, this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool biometric = true;
  bool autoLock = true;
  bool cloudSync = false;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
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
                  onTap: widget.onBack,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
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
                  _buildSectionHeader('Security'),
                  _buildToggleRow(
                    'Biometric Unlock',
                    'Use Face ID or Fingerprint',
                    biometric,
                    (v) => setState(() => biometric = v),
                  ),
                  const SizedBox(height: 8),
                  _buildToggleRow(
                    'Auto-Lock',
                    'Lock after 5 minutes of inactivity',
                    autoLock,
                    (v) => setState(() => autoLock = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Sync & Backup'),
                  _buildToggleRow(
                    'Cloud Sync',
                    'Sync vault across devices',
                    cloudSync,
                    (v) => setState(() => cloudSync = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Appearance'),
                  _buildToggleRow(
                    'Dark Mode',
                    'Always on dark theme',
                    darkMode,
                    (v) => setState(() => darkMode = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Data'),
                  _buildButton('Export Vault', onTap: () {}),
                  const SizedBox(height: 8),
                  _buildButton(
                    'Clear All Data',
                    isDestructive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.45),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.08,
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    String label,
    String sub,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: value ? AppGradients.primary : null,
                color: value
                    ? null
                    : AppColors.textMuted.withValues(alpha: 0.1),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    left: value ? 25 : 3,
                    top: 3,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDestructive
              ? AppColors.error
              : AppColors.textPrimary,
          side: BorderSide(
            color: isDestructive
                ? AppColors.error.withValues(alpha: 0.2)
                : AppColors.cardBorder,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
