import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isOutlined;

  const GoldButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: isOutlined ? null : AppTheme.goldGradient,
          color: isOutlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(20),
          border: isOutlined
              ? Border.all(color: AppTheme.islamicGold, width: 1.5)
              : null,
          boxShadow: isOutlined ? null : AppTheme.goldGlow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isOutlined ? AppTheme.islamicGold : AppTheme.carbonBlack,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTheme.bodyLarge.copyWith(
                color: isOutlined ? AppTheme.islamicGold : AppTheme.carbonBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
