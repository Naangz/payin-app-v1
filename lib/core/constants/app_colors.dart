import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFEBF4FF);
  static const primaryDark = Color(0xFF1D4ED8);
  
  // Semantic colors
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFFECFDF5);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEF2F2);
  
  // Neutral colors
  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;
  static const surfaceVariant = Color(0xFFF8FAFC);
  
  // Text colors
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textHint = Color(0xFFD1D5DB);  
  
  // Border colors
  static const border = Color(0xFFE5E7EB);
  static const borderFocus = Color(0xFF2563EB);
}
class AppTextStyles {
  static const h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
}
