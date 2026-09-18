import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onSignup;
  final VoidCallback? onForgot;

  const LoginScreen({super.key, this.onLogin, this.onSignup, this.onForgot});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(text: 'alex.morgan@gmail.com');
  final passwordController = TextEditingController(text: 'MyMasterPass!');
  bool showPw = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Unlock your vault to continue',
              style: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.45),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            // Biometric button
            GestureDetector(
              onTap: widget.onLogin,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.fingerprint, size: 40, color: AppColors.primary),
                    const SizedBox(height: 10),
                    Text(
                      'Use Biometrics',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Face ID or Fingerprint',
                      style: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.35),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.textMuted.withValues(alpha: 0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or sign in with master password',
                    style: TextStyle(
                      color: AppColors.textMuted.withValues(alpha: 0.35),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.textMuted.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Email field
            _buildLabel('Email'),
            const SizedBox(height: 6),
            _buildTextField(emailController),
            const SizedBox(height: 12),
            // Password field
            _buildLabel('Master Password'),
            const SizedBox(height: 6),
            _buildTextField(passwordController, isPassword: true),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onForgot,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Unlock Vault',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New here? ',
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSignup,
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted.withValues(alpha: 0.55),
        letterSpacing: 0.04,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPw,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPw
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.textMuted.withValues(alpha: 0.4),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
