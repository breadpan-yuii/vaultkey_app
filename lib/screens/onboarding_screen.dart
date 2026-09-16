import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onNext;
  const OnboardingScreen({super.key, this.onNext});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;

  final slides = [
    (
      icon: Icons.shield_rounded,
      title: 'Bank-Grade Security',
      desc: 'AES-256 encryption protects every password. Your data never leaves your device without your consent.',
    ),
    (
      icon: Icons.fingerprint,
      title: 'Biometric Access',
      desc: 'Unlock instantly with Face ID or fingerprint. No master password to forget.',
    ),
    (
      icon: Icons.key_rounded,
      title: 'Smart Password Generator',
      desc: 'Create unique, unbreakable passwords for every account in one tap.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final slide = slides[step];
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Icon(slide.icon, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            slide.desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.55),
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: i == step ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: i == step ? AppColors.primary : AppColors.textMuted.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (step < slides.length - 1) {
                  setState(() => step++);
                } else {
                  widget.onNext?.call();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                step < slides.length - 1 ? 'Next' : 'Get Started',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          if (step < slides.length - 1)
            TextButton(
              onPressed: widget.onNext,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
