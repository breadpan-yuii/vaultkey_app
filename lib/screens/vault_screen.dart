import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../models/models.dart';
import '../providers/password_provider.dart';
import '../widgets/shared_widgets.dart';

class VaultScreen extends StatefulWidget {
  final ValueChanged<String>? onNav;
  final ValueChanged<PasswordEntry>? onDetail;

  const VaultScreen({super.key, this.onNav, this.onDetail});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  Category? activeFilter;
  String sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, provider, _) {
        List<PasswordEntry> filtered = activeFilter != null
            ? provider.filterByCategory(activeFilter)
            : provider.passwords;

        final sorted = [...filtered]
          ..sort((a, b) {
            if (sortBy == 'name') return a.title.compareTo(b.title);
            if (sortBy == 'strength') {
              return a.strength.index.compareTo(b.strength.index);
            }
            return 0;
          });

        return Container(
          color: AppColors.background,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.cardBorder),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Vault',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => widget.onNav?.call('search'),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBg,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.cardBorder,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: AppColors.textPrimary.withValues(
                                        alpha: 0.7,
                                      ),
                                      size: 17,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: sortBy,
                                    underline: const SizedBox(),
                                    dropdownColor: AppColors.surface,
                                    style: TextStyle(
                                      color: AppColors.textPrimary.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 12,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'name',
                                        child: Text('A–Z'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'strength',
                                        child: Text('Strength'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'date',
                                        child: Text('Date'),
                                      ),
                                    ],
                                    onChanged: (v) =>
                                        setState(() => sortBy = v ?? 'name'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 32,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildFilterChip('All', null),
                              ...Category.values.map(
                                (cat) => _buildFilterChip(
                                  categoryMeta[cat]!.label,
                                  cat,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: sorted.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 48,
                                  color: AppColors.textMuted.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  provider.passwords.isEmpty
                                      ? 'No passwords yet'
                                      : 'No passwords in this category',
                                  style: TextStyle(
                                    color: AppColors.textMuted.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (provider.passwords.isEmpty)
                                  TextButton(
                                    onPressed: () => widget.onNav?.call('add'),
                                    child: const Text(
                                      'Add your first password',
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                            itemCount: sorted.length,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: PasswordCard(
                                pw: sorted[i],
                                onTap: () => widget.onDetail?.call(sorted[i]),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 24,
                child: FloatingActionButton(
                  onPressed: () => widget.onNav?.call('add'),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, Category? cat) {
    final isActive = activeFilter == cat;
    final meta = cat != null ? categoryMeta[cat] : null;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => activeFilter = cat),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isActive
                ? (meta?.bg ?? AppColors.primary.withValues(alpha: 0.15))
                : AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? (meta?.color ?? AppColors.primary)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? (meta?.color ?? AppColors.primary)
                    : AppColors.textMuted.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
