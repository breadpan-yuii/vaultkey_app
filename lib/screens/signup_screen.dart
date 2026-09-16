import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_widgets.dart';
import '../models/models.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSignup;

  const SignupScreen({super.key, this.onBack, this.onSignup});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool showPw = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(),
            const SizedBox(height: 16),
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              'Set up your secure vault',
              style: TextStyle(color: AppColors.textMuted.withOpacity(0.45), fontSize: 14),
            ),
            const SizedBox(height: 28),
            _buildLabel('Full Name'),
            const SizedBox(height: 6),
            _buildTextField('Alex Morgan'),
            const SizedBox(height: 14),
            _buildLabel('Email Address'),
            const SizedBox(height: 6),
            _buildTextField('alex.morgan@gmail.com'),
            const SizedBox(height: 14),
            _buildLabel('Master Password'),
            const SizedBox(height: 6),
            _buildTextField('MyStr0ng!Pass', isPassword: true),
            const SizedBox(height: 8),
            const StrengthBars(level: PasswordStrength.strong),
            const SizedBox(height: 14),
            _buildLabel('Confirm Password'),
            const SizedBox(height: 6),
            _buildTextField('MyStr0ng!Pass', isPassword: true),
            const SizedBox(height: 14),
            // Info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your master password is never stored. We can\'t recover it if lost. Store it safely.',
                      style: TextStyle(
                        color: AppColors.textMuted.withOpacity(0.55),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Create Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: widget.onBack,
      child: Row(
        children: [
          Icon(Icons.chevron_left_rounded, color: AppColors.textMuted.withOpacity(0.6)),
          Text(
            'Back',
            style: TextStyle(color: AppColors.textMuted.withOpacity(0.6), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted.withOpacity(0.55),
        letterSpacing: 0.04,
      ),
    );
  }

  Widget _buildTextField(String initialValue, {bool isPassword = false}) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      obscureText: isPassword && !showPw,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPw ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.textMuted.withOpacity(0.4),
                ),
                onPressed: () => setState(() => showPw = !showPw),
              )
            : null,
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
