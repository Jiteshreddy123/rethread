import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable small status/category chip badge for item condition, status, and categories.
class CustomBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const CustomBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.surfaceVariant,
    this.textColor = AppColors.textPrimary,
    this.icon,
  });

  factory CustomBadge.condition(String condition) {
    Color bg;
    Color fg;
    switch (condition.toLowerCase()) {
      case 'like new':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'good':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1976D2);
        break;
      case 'fair':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      case 'needs repair':
        bg = const Color(0xFFFBE9E7);
        fg = const Color(0xFFD84315);
        break;
      default:
        bg = AppColors.surfaceVariant;
        fg = AppColors.textSecondary;
    }
    return CustomBadge(label: condition, backgroundColor: bg, textColor: fg);
  }

  factory CustomBadge.status(String status) {
    Color bg;
    Color fg;
    switch (status.toLowerCase()) {
      case 'available':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'requested':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        break;
      case 'accepted':
        bg = const Color(0xFFE1F5FE);
        fg = const Color(0xFF0288D1);
        break;
      case 'handed over':
        bg = const Color(0xFFEDE7F6);
        fg = const Color(0xFF512DA8);
        break;
      default:
        bg = AppColors.surfaceVariant;
        fg = AppColors.textSecondary;
    }
    return CustomBadge(label: status, backgroundColor: bg, textColor: fg);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
