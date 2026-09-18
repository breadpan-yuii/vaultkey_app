import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PasswordStrength { weak, fair, strong, excellent }

enum Category { social, banking, email, shopping, work, other }

class PasswordEntry {
  final String id;
  final String title;
  final String username;
  final String password;
  final String website;
  final Category category;
  final PasswordStrength strength;
  final String lastUpdated;
  final bool favorite;
  final String notes;

  const PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.website,
    required this.category,
    required this.strength,
    required this.lastUpdated,
    this.favorite = false,
    this.notes = '',
  });
}

class CategoryMeta {
  final String label;
  final Color color;
  final Color bg;
  final IconData icon;

  const CategoryMeta({
    required this.label,
    required this.color,
    required this.bg,
    required this.icon,
  });
}

const Map<Category, CategoryMeta> categoryMeta = {
  Category.social: CategoryMeta(
    label: 'Social',
    color: AppColors.social,
    bg: Color(0x1FA78BFA),
    icon: Icons.people_outline,
  ),
  Category.banking: CategoryMeta(
    label: 'Banking',
    color: AppColors.banking,
    bg: Color(0x1F34D399),
    icon: Icons.account_balance_outlined,
  ),
  Category.email: CategoryMeta(
    label: 'Email',
    color: AppColors.email,
    bg: Color(0x1F60A5FA),
    icon: Icons.email_outlined,
  ),
  Category.shopping: CategoryMeta(
    label: 'Shopping',
    color: AppColors.shopping,
    bg: Color(0x1FF472B6),
    icon: Icons.shopping_bag_outlined,
  ),
  Category.work: CategoryMeta(
    label: 'Work',
    color: AppColors.work,
    bg: Color(0x1FFCD34D),
    icon: Icons.work_outline,
  ),
  Category.other: CategoryMeta(
    label: 'Other',
    color: AppColors.other,
    bg: Color(0x1F94A3B8),
    icon: Icons.bookmark_outline,
  ),
};

class StrengthMeta {
  final Color color;
  final String label;
  final int bars;

  const StrengthMeta({
    required this.color,
    required this.label,
    required this.bars,
  });
}

const Map<PasswordStrength, StrengthMeta> strengthMeta = {
  PasswordStrength.weak: StrengthMeta(
    color: AppColors.strengthWeak,
    label: 'Weak',
    bars: 1,
  ),
  PasswordStrength.fair: StrengthMeta(
    color: AppColors.strengthFair,
    label: 'Fair',
    bars: 2,
  ),
  PasswordStrength.strong: StrengthMeta(
    color: AppColors.strengthStrong,
    label: 'Strong',
    bars: 3,
  ),
  PasswordStrength.excellent: StrengthMeta(
    color: AppColors.strengthExcellent,
    label: 'Excellent',
    bars: 4,
  ),
};

final List<PasswordEntry> mockPasswords = [
  const PasswordEntry(
    id: '1',
    title: 'Gmail',
    username: 'alex.morgan@gmail.com',
    password: 'Tr0ub4dor&3',
    website: 'gmail.com',
    category: Category.email,
    strength: PasswordStrength.strong,
    lastUpdated: '2 days ago',
    favorite: true,
    notes: 'Primary email account',
  ),
  const PasswordEntry(
    id: '2',
    title: 'Chase Bank',
    username: 'alexmorgan92',
    password: 'B@nk\$ecure2024!',
    website: 'chase.com',
    category: Category.banking,
    strength: PasswordStrength.excellent,
    lastUpdated: '1 week ago',
    favorite: true,
    notes: 'Joint account',
  ),
  const PasswordEntry(
    id: '3',
    title: 'Instagram',
    username: '@alex.morgan',
    password: 'Gr@m2024!',
    website: 'instagram.com',
    category: Category.social,
    strength: PasswordStrength.strong,
    lastUpdated: '3 days ago',
  ),
  const PasswordEntry(
    id: '4',
    title: 'Amazon',
    username: 'alex.morgan@gmail.com',
    password: 'Shop1ng!',
    website: 'amazon.com',
    category: Category.shopping,
    strength: PasswordStrength.fair,
    lastUpdated: '2 weeks ago',
    notes: 'Prime account',
  ),
  const PasswordEntry(
    id: '5',
    title: 'Slack – Acme Corp',
    username: 'alex.morgan@acme.io',
    password: 'W0rk#Sl4ck2024',
    website: 'acme.slack.com',
    category: Category.work,
    strength: PasswordStrength.excellent,
    lastUpdated: '1 day ago',
    favorite: true,
    notes: 'Work workspace',
  ),
  const PasswordEntry(
    id: '6',
    title: 'Netflix',
    username: 'alex.morgan@gmail.com',
    password: 'Str3am!ng',
    website: 'netflix.com',
    category: Category.other,
    strength: PasswordStrength.fair,
    lastUpdated: '1 month ago',
    notes: 'Family plan',
  ),
  const PasswordEntry(
    id: '7',
    title: 'Twitter / X',
    username: '@alexmorgan',
    password: 'Tw33t\$2024!',
    website: 'x.com',
    category: Category.social,
    strength: PasswordStrength.strong,
    lastUpdated: '5 days ago',
  ),
  const PasswordEntry(
    id: '8',
    title: 'LinkedIn',
    username: 'alex-morgan',
    password: 'L1nked!n24',
    website: 'linkedin.com',
    category: Category.work,
    strength: PasswordStrength.strong,
    lastUpdated: '3 weeks ago',
    notes: 'Professional profile',
  ),
];

PasswordStrength calculateStrength(String password) {
  if (password.length >= 16 &&
      RegExp(r'[!@#$%^&*]').hasMatch(password) &&
      RegExp(r'[0-9]').hasMatch(password)) {
    return PasswordStrength.excellent;
  } else if (password.length >= 12) {
    return PasswordStrength.strong;
  } else if (password.length >= 8) {
    return PasswordStrength.fair;
  }
  return PasswordStrength.weak;
}
