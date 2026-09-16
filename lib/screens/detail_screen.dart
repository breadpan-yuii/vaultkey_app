import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../providers/password_provider.dart';
import '../widgets/shared_widgets.dart';

class DetailScreen extends StatefulWidget {
  final PasswordEntry pw;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;

  const DetailScreen({super.key, required this.pw, this.onBack, this.onEdit});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool showPw = false;
  String? copied;
  bool showDeleteDialog = false;

  void handleCopy(String label, String value) {
    copyToClipboard(context, label, value);
    setState(() => copied = label);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => copied = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pw = widget.pw;
    final cat = categoryMeta[pw.category]!;

    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  decoration: const BoxDecoration(gradient: AppGradients.detailHeader),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: widget.onBack,
                            child: Row(
                              children: [
                                Icon(Icons.chevron_left_rounded, color: AppColors.textMuted.withOpacity(0.6)),
                                Text('Back', style: TextStyle(color: AppColors.textMuted.withOpacity(0.6), fontSize: 14)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: widget.onEdit,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.cardBorder),
                                  ),
                                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => setState(() => showDeleteDialog = true),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                                  ),
                                  child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: cat.bg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Icon(cat.icon, color: cat.color, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pw.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  CategoryChip(cat: pw.category),
                                  if (pw.favorite) ...[
                                    const SizedBox(width: 8),
                                    const Icon(Icons.star, color: AppColors.work, size: 14),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StrengthBars(level: pw.strength),
                      const SizedBox(height: 20),
                      _buildInfoCard('Username / Email', Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(pw.username, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'JetBrains Mono'))),
                          _buildCopyButton('username', pw.username),
                        ],
                      )),
                      const SizedBox(height: 10),
                      _buildInfoCard('Password', Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              showPw ? pw.password : maskPassword(pw.password),
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'JetBrains Mono'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildIconButton(showPw ? Icons.visibility_off_rounded : Icons.visibility_rounded, () => setState(() => showPw = !showPw)),
                              const SizedBox(width: 6),
                              _buildCopyButton('password', pw.password),
                            ],
                          ),
                        ],
                      )),
                      const SizedBox(height: 10),
                      _buildInfoCard('Website', Row(
                        children: [
                          const Icon(Icons.language_rounded, size: 14, color: AppColors.email),
                          const SizedBox(width: 8),
                          Text(pw.website, style: const TextStyle(color: AppColors.email, fontSize: 14)),
                        ],
                      )),
                      const SizedBox(height: 10),
                      if (pw.notes.isNotEmpty) ...[
                        _buildInfoCard('Notes', Text(pw.notes, style: TextStyle(color: AppColors.textPrimary.withOpacity(0.65), fontSize: 14, height: 1.5))),
                        const SizedBox(height: 10),
                      ],
                      _buildInfoCard('Last Updated', Text(pw.lastUpdated, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14))),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: widget.onEdit,
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text('Edit Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          if (showDeleteDialog)
            GestureDetector(
              onTap: () => setState(() => showDeleteDialog = false),
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.error.withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22),
                          ),
                          const SizedBox(height: 14),
                          const Text('Delete Password?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text(
                            '"${pw.title}" will be permanently removed from your vault.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted.withOpacity(0.45), fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => setState(() => showDeleteDialog = false),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    side: const BorderSide(color: AppColors.cardBorder),
                                  ),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<PasswordProvider>().deletePassword(int.parse(pw.id));
                                    setState(() => showDeleteDialog = false);
                                    widget.onBack?.call();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted.withOpacity(0.4), letterSpacing: 0.06)),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _buildCopyButton(String label, String value) {
    final isCopied = copied == label;
    return GestureDetector(
      onTap: () => handleCopy(label, value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isCopied ? AppColors.primary.withOpacity(0.2) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isCopied ? Icons.check_rounded : Icons.copy_rounded, size: 14, color: isCopied ? AppColors.primary : AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(width: 4),
            Text(isCopied ? 'Copied!' : 'Copy', style: TextStyle(color: isCopied ? AppColors.primary : AppColors.textMuted.withOpacity(0.5), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppColors.textMuted.withOpacity(0.5), size: 18),
      ),
    );
  }
}
