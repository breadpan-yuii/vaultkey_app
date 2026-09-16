import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ForgotPasswordScreen({super.key, this.onBack});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(),
          const SizedBox(height: 16),
          const Text(
            'Reset Password',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'We\'ll send a reset link to your email',
            style: TextStyle(color: AppColors.textMuted.withOpacity(0.45), fontSize: 14),
          ),
          const SizedBox(height: 28),
          if (!sent) ...[
            _buildLabel('Email Address'),
            const SizedBox(height: 6),
            TextField(
              controller: TextEditingController(text: 'alex.morgan@gmail.com'),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => sent = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Send Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ] else ...[
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.check_rounded, size: 36, color: AppColors.success),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Check your email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: AppColors.textMuted.withOpacity(0.45), fontSize: 14, height: 1.6),
                      children: [
                        const TextSpan(text: 'We sent a reset link to\n'),
                        TextSpan(
                          text: 'alex.morgan@gmail.com',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Back to Login', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ],
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
}
