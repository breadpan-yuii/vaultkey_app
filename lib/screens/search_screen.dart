import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../providers/password_provider.dart';
import '../widgets/shared_widgets.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final ValueChanged<PasswordEntry>? onDetail;

  const SearchScreen({super.key, this.onBack, this.onDetail});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordProvider>(
      builder: (context, provider, _) {
        final results = provider.search(query);

        return Container(
          color: AppColors.background,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 20, 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (v) => setState(() => query = v),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Search passwords…',
                          hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.3)),
                          prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted.withOpacity(0.4), size: 18),
                          filled: true,
                          fillColor: AppColors.cardBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: query.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.2)),
                            const SizedBox(height: 16),
                            Text('Search by name, username, or website', style: TextStyle(color: AppColors.textMuted.withOpacity(0.4), fontSize: 15)),
                          ],
                        ),
                      )
                    : results.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.textMuted),
                                const SizedBox(height: 16),
                                const Text('No results found', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                Text('Try a different search term', style: TextStyle(color: AppColors.textMuted.withOpacity(0.4), fontSize: 14)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: results.length + 1,
                            itemBuilder: (context, i) {
                              if (i == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    '${results.length} result${results.length != 1 ? 's' : ''} for "$query"',
                                    style: TextStyle(color: AppColors.textMuted.withOpacity(0.4), fontSize: 13),
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: PasswordCard(pw: results[i - 1], onTap: () => widget.onDetail?.call(results[i - 1])),
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
}
