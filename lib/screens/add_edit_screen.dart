import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../providers/password_provider.dart';
import '../widgets/shared_widgets.dart';

class AddEditScreen extends StatefulWidget {
  final PasswordEntry? pw;
  final VoidCallback? onBack;
  final VoidCallback? onSave;

  const AddEditScreen({super.key, this.pw, this.onBack, this.onSave});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  late TextEditingController titleController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController websiteController;
  late TextEditingController notesController;
  late Category category;
  bool showPw = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    isEditing = widget.pw != null;
    titleController = TextEditingController(text: widget.pw?.title ?? '');
    usernameController = TextEditingController(text: widget.pw?.username ?? '');
    passwordController = TextEditingController(text: widget.pw?.password ?? '');
    websiteController = TextEditingController(text: widget.pw?.website ?? '');
    notesController = TextEditingController(text: widget.pw?.notes ?? '');
    category = widget.pw?.category ?? Category.other;
  }

  @override
  void dispose() {
    titleController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    notesController.dispose();
    super.dispose();
  }

  PasswordStrength get strengthLevel => calculateStrength(passwordController.text);

  void generatePassword() {
    setState(() {
      passwordController.text = generateRandomPassword();
    });
  }

  void _save() {
    final provider = context.read<PasswordProvider>();
    final created = PasswordEntry(
      id: isEditing ? widget.pw!.id : '0',
      title: titleController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text,
      website: websiteController.text.trim(),
      category: category,
      strength: strengthLevel,
      lastUpdated: 'Just now',
      favorite: widget.pw?.favorite ?? false,
      notes: notesController.text.trim(),
    );
    final future = isEditing
        ? provider.updatePassword(created)
        : provider.addPassword(created);
    future.whenComplete(() {
      if (mounted) widget.onSave?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: widget.onBack,
                  child: const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted),
                ),
                const SizedBox(width: 14),
                Text(
                  isEditing ? 'Edit Password' : 'Add Password',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Title'),
                  const SizedBox(height: 6),
                  _buildTextField(titleController, 'e.g. Gmail, GitHub…'),
                  const SizedBox(height: 14),
                  _buildLabel('Username / Email'),
                  const SizedBox(height: 6),
                  _buildTextField(usernameController, 'your@email.com'),
                  const SizedBox(height: 14),
                  _buildLabel('Website'),
                  const SizedBox(height: 6),
                  _buildTextField(websiteController, 'example.com'),
                  const SizedBox(height: 14),
                  _buildLabel('Password'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPw,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontFamily: 'JetBrains Mono'),
                    decoration: InputDecoration(
                      hintText: 'Enter or generate a password',
                      hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.3)),
                      filled: true,
                      fillColor: AppColors.cardBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(showPw ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textMuted.withOpacity(0.5), size: 15),
                            onPressed: () => setState(() => showPw = !showPw),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh_rounded, color: AppColors.primary, size: 15),
                            onPressed: generatePassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (passwordController.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    StrengthBars(level: strengthLevel),
                  ],
                  const SizedBox(height: 14),
                  _buildLabel('Category'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Category.values.map((cat) {
                      final m = categoryMeta[cat]!;
                      final isActive = category == cat;
                      return GestureDetector(
                        onTap: () => setState(() => category = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isActive ? m.bg : AppColors.cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isActive ? m.color : AppColors.cardBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(m.icon, size: 14, color: isActive ? m.color : AppColors.textMuted.withOpacity(0.5)),
                              const SizedBox(width: 4),
                              Text(m.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? m.color : AppColors.textMuted.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  _buildLabel('Notes (optional)'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Add any notes about this account…',
                      hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.3)),
                      filled: true,
                      fillColor: AppColors.cardBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add to Vault',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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

  Widget _buildLabel(String text) {
    return Text(text.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted.withOpacity(0.55), letterSpacing: 0.04));
  }

  Widget _buildTextField(TextEditingController controller, String placeholder) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.3)),
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      ),
    );
  }
}
